"""
    $SIGNATURES

Internal function to apply a vector of `Drawing` objects contained in an `Axes`
container in a GLE context. The `axorigin` and `figid` help keep track of
where individual drawings belong to which is useful when writing auxiliary files
containing the drawing data.
"""
function apply_drawings!(g::GLE, drawings::Vector{<:Drawing},
                         axorigin::T2F, figid::String)
    leg_entries = GLE()
    # element counter to have an index over objects drawn
    el_cntr = 1
    for drawing ∈ drawings
        el_cntr = apply_drawing!(g, leg_entries, drawing,
                                 el_cntr, axorigin, figid)
    end
    # this is recuperated in `apply_axes!` and further processed by `apply_legend!`
    return leg_entries
end

"""
    $SIGNATURES

Internal function to generate a path to an auxiliary file storing drawing data for the current
axes of the current figure. `h` is the hash of what has to be written (so that if the exact
same command is issued, the file is not re-written). The `origin` and `figid` are there to make
the auxiliary file unique and easy to delete after use.
"""
function auxpath(h::UInt, origin::T2F, figid::String)
    path = GP_ENV["TMP_PATH"]
    axid = isdef(origin) ? "$(origin[1])_$(origin[2])" : ""
    return joinpath(path, "$(figid)_$(axid)_$h.csv")
end

####
#### Apply a Scatter2D object
####

"""
    $SIGNATURES

Internal function to apply a `Drawing` object `obj` in a GLE context `g` with current
legend entries `leg_entries` (possibly empty), current element counter `el_counter`
and `origin` and `figid` are used to make the auxiliary file name unique.
"""
function apply_drawing!(g::GLE, leg_entries::GLE, scatter::Scatter2D,
                        el_counter::Int, origin::T2F, figid::String)
    # temporary buffers to help build the legend
    lt = [GLE() for c ∈ 1:scatter.nobj]

    faux = auxpath(hash(scatter.data), origin, figid)
    # don't rewrite if it's the exact same zipper
    isfile(faux) || csv_writer(faux, scatter.data, scatter.hasmissing)

    #
    # GLE syntax is:
    #
    #   data datafile.dat d1=c1,c2
    #   d1 line blue
    #

    for c ∈ eachindex(lt)
        # (1) indicate what data to read
        "\n\tdata \"$faux\" d$(el_counter)=c1,c$(c+1)" |> g
        # if no color has been specified, assign one according to the PALETTE
        if !isdef(scatter.linestyles[c].color)
            cc = mod(el_counter, GP_ENV["SIZE_PALETTE"])
            (cc == 0) && (cc = GP_ENV["SIZE_PALETTE"])
            scatter.linestyles[c].color = GP_ENV["PALETTE"][cc]
        end
        # (2) line and marker description
        # build a tuple with the current buffer and the legend entry buffer
        if scatter.linestyles[c].lstyle != -1
            # Line plot
            "\n\td$el_counter" |> g
            "line" |> g;     apply_linestyle!(g, scatter.linestyles[c])
            "line" |> lt[c]; apply_linestyle!(lt[c], scatter.linestyles[c], legend=true)
            # if a marker color is specified and different than the line
            # color we need to have a special subroutine for GLE
            mcol_flag = false
            if isdef(scatter.markerstyles[c].color) &&
                    (scatter.markerstyles[c].color != scatter.linestyles[c].color)
                mcol_flag = true
                add_sub_marker!(Figure(figid; _noreset=true), scatter.markerstyles[c])
            end
            # apply markerstyle to the axes & the legend
            apply_markerstyle!(g, scatter.markerstyles[c], mcol_flag=mcol_flag)
            apply_markerstyle!(lt[c], scatter.markerstyles[c], mcol_flag=mcol_flag)
        else
            # Scatter plot; if there's no specified marker color,
            # take the default line color
            if !isdef(scatter.markerstyles[c].color)
                scatter.markerstyles[c].color = scatter.linestyles[c].color
            end
            # apply markerstyle to the axes & legend
            "\n\td$el_counter" |> g
            apply_markerstyle!(g, scatter.markerstyles[c])
            apply_markerstyle!(lt[c], scatter.markerstyles[c])
        end
    end
    # (3) build legend entries (will be applied if a legend command is issued)
    if isempty(scatter.labels)
        for c ∈ eachindex(lt)
            "\n\ttext \"plot $(el_counter-1+c)\"" |> leg_entries
            lt[c] |> leg_entries
        end
    else
        for c ∈ eachindex(lt)
            "\n\ttext \"$(scatter.labels[c])\"" |> leg_entries
            lt[c] |> leg_entries
        end
    end
    return el_counter + scatter.nobj
end

####
#### Apply a Fill2D object
####

function apply_drawing!(g::GLE, leg_entries::GLE, fill::Fill2D,
                        el_counter::Int, origin::T2F, figid::String)

    faux = auxpath(hash(fill.data), origin, figid)
    isfile(faux) || csv_writer(faux, fill.data, false)

    #
    # GLE syntax is:
    #
    #   data datafile.dat d1=c1,c2 d2=c1,c3
    #   fill d1,d2 color rgb(1,1,1) xmin 0 xmax 1
    #

    "\n\tdata \"$faux\" d$(el_counter)=c1,c2 d$(el_counter+1)=c1,c3" |> g
    "\n\tfill d$(el_counter),d$(el_counter+1)" |> g
    "color $(col2str(fill.fillstyle.fill))"    |> g
    isdef(fill.xmin) && "xmin $(fill.xmin)"    |> g
    isdef(fill.xmax) && "xmax $(fill.xmax)"    |> g

    #
    # Legend
    #
    if isempty(fill.label)
        "\n\ttext \"fill $(el_counter)\"" |> leg_entries
    else
        "\n\ttext \"$(fill.label)\""      |> leg_entries
    end
    "fill $(col2str(fill.fillstyle.fill))" |> leg_entries

    el_counter += 2
    return el_counter
end

####
#### Apply a Hist2D object
####

function apply_drawing!(g::GLE, leg_entries::GLE, hist::Hist2D,
                        el_counter::Int, origin::T2F, figid::String)

    # write data to a temporary CSV file
    faux = auxpath(hash(hist.data), origin, figid)
    isfile(faux) || csv_writer(faux, hist.data, hist.hasmissing)

    #
    # GLE syntax is:
    #
    #   data datafile.dat d1
    #   let d2 = hist d1 from xmin to xmax bins nbins
    #   bar d2 width width$ fill col$ color col2$ pattern pat$ horiz
    #

    # if no color has been specified, assign one according to the PALETTE
    if !isdef(hist.barstyle.color)
        if hist.barstyle.fill == colorant"white"
            cc = mod(el_counter, GP_ENV["SIZE_PALETTE"])
            (cc == 0) && (cc = GP_ENV["SIZE_PALETTE"])
            hist.barstyle.color = GP_ENV["PALETTE"][cc]
        else
            hist.barstyle.color = colorant"white" # looks nicer than black
        end
    end

    # (1) indicate what data to read
    "\n\tdata \"$faux\" d$(el_counter)" |> g

    # (2) hist description
    minx, maxx = hist.range
    "\n\tlet d$(el_counter+1) = hist d$(el_counter)" |> g
    "from $minx to $maxx" |> g
    el_counter += 1

    # number of bins (TODO: better criterion, see StatsPlots.jl)
    nobs = hist.nobs
    nbauto = (nobs < 10) * nobs +
             (10 <= nobs < 30) * 10 +
             (nobs > 30) * min(round(Int, sqrt(nobs)), 150)
    bins = isdef(hist.bins) ? hist.bins : nbauto
    "bins $bins" |> g

    # (3) compute appropriate scaling
    width   = (maxx - minx) / bins
    scaling = 1.0
    hist.scaling == "probability" && (scaling /= nobs)
    hist.scaling == "pdf"         && (scaling /= (nobs * width))
    "\n\tlet d$(el_counter) = d$(el_counter)*$scaling" |> g

    # (4) apply histogram
    "\n\tbar d$(el_counter) width $width" |> g

    # apply styling
    apply_barstyle!(g, hist.barstyle)
    hist.horiz && "horiz" |> g

    #
    # Legend
    #
    if isempty(hist.label)
        "\n\ttext \"hist $(el_counter)\"" |> leg_entries
    else
        "\n\ttext \"$(hist.label)\""      |> leg_entries
    end
    # precedence of fill over color
    if hist.barstyle.fill != colorant"white"
        "fill $(col2str(hist.barstyle.fill))" |> leg_entries
    else
        "marker square color $(col2str(hist.barstyle.color))" |> leg_entries
    end

    return el_counter+1
end

####
#### Apply Bar2D
####

function apply_drawing!(g::GLE, leg_entries::GLE, bar::Bar2D,
                        el_counter::Int, origin::T2F, figid::String)
    # write data to a temporary CSV file
    faux = auxpath(hash(bar.data), origin, figid)
    isfile(faux) || csv_writer(faux, bar.data, bar.hasmissing)

    # >>>>>>>>>>>>>>>>
    # general GLE syntax is:
    # (1) data datafile.dat d1 d2 ...
    # (2) bar d1,d2,d3 fill color_ color color_
    # (STACKED, NO GROUP)
    # bar d1 ...
    # bar d2 from d1 ...
    # XXX (STACKED, GROUP) ---> see first whether this has a use case...
    # could solve it by specifying what gets stacked stack=[(1, 2), ...] but
    # clunky (and tbf not great visualisation anyway...)
    # bar d1,d2 ...
    # bar d3,d4 from d1,d2 ...
    # <<<<<<<<<<<<<<<<

    # if no color has been specified, assign one according to the PALETTE
    for c ∈ eachindex(bar.barstyles)
        if !isdef(bar.barstyles[c].color)
            if bar.barstyles[c].fill == colorant"white"
                cc = mod(el_counter+c-1, GP_ENV["SIZE_PALETTE"])
                (cc == 0) && (cc = GP_ENV["SIZE_PALETTE"])
                bar.barstyles[c].color = GP_ENV["PALETTE"][cc]
            else
                bar.barstyles[c].color = colorant"white"
            end
        end
    end

    nbars = bar.nobj

    # (1) indicate what data to read "data file d1 d2 d3..."
    "\n\tdata \"$faux\"" |> g
    prod("d$(el_counter+i-1) " for i ∈ (1:nbars)) |> g

    # (2) non stacked (or single barset)
    if nbars==1 || !bar.stacked
        # bar d1,d2,d3
        "\n\tbar $(svec2str(("d$(el_counter+i-1)" for i ∈ 1:nbars)))" |> g
        isdef(bar.width) && "width $(bar.width)" |> g
        # apply bar styles
        apply_barstyles_nostack!(g, bar.barstyles)
        bar.horiz && "horiz" |> g

    # (2) stacked
    else
        # first base bar
        "\n\tbar d$(el_counter)" |> g
        isdef(bar.width) && "width $(bar.width)" |> g
        apply_barstyle!(g, bar.barstyles[1])
        bar.horiz && "horiz" |> g
        # bars stacked on top
        for i ∈ 2:nbars
            "\n\tbar d$(el_counter+i-1) from d$(el_counter+i-2)" |> g
            apply_barstyle!(g, bar.barstyles[i])
        end
    end

    #
    # Legend
    #
    if isempty(bar.labels)
        c = 0
        for barstyle ∈ bar.barstyles
            "\n\ttext \"bar $(el_counter+c)\"" |> leg_entries
            c += 1
            # fill takes precedence
            if barstyle.fill != colorant"white"
                "fill $(col2str(barstyle.fill))" |> leg_entries
            else
                "marker square color $(col2str(barstyle.color))" |> leg_entries
            end
        end
    else
        for (lab, barstyle) ∈ zip(bar.labels, bar.barstyles)
            "\n\ttext \"$(lab)\"" |> leg_entries
            # fill takes precedence
            if barstyle.fill != colorant"white"
                "fill $(col2str(barstyle.fill))" |> leg_entries
            else
                "marker square color $(col2str(barstyle.color))" |> leg_entries
            end
        end
    end

    return el_counter + nbars
end
