"""
    $SIGNATURES

Internal function to apply a vector of `Drawing` objects contained in an `Axes` container in a GLE
context. The `axidx` and `figid` help keep track of where individual drawings belong to which is
useful when writing auxiliary files containing the drawing data.
"""
function apply_drawings!(g::GLE, drawings::Vector{<:Drawing}, figid::String, axidx::Int)
    # element counter to have an index over objects drawn
    el_cntr = 1
    for drawing ∈ drawings
        el_cntr = apply_drawing!(g, drawing, el_cntr, figid, axidx)
    end
    # this is recuperated in `apply_axes!` and further processed by `apply_legend!`
    return nothing
end

"""
    $SIGNATURES

Internal function to generate a path to an auxiliary file storing drawing data for the current
axes of the current figure. The argument `h` is the hash of what has to be written (so that if
the exact same command is issued, the file is not re-written). The `axidx` and `figid` are there
to make the auxiliary file unique and easy to delete after use.
"""
auxpath(h::UInt, fid::String, axid::Int) = joinpath(GP_ENV["TMP_PATH"], "$(fid)_$(axid)_$h.csv")

####
#### Apply a Scatter2D object
####

"""
    $SIGNATURES

Internal function to apply a `Drawing` object `obj` in a GLE context `g` with current legend
entries `leg_entries` (possibly empty), current element counter `el_cntr` and `axidx` and `figid`
are used to make the auxiliary file name unique.
"""
function apply_drawing!(g::GLE, scatter::Scatter2D, el_cntr::Int, figid::String, axidx::Int)
    # write data to a temporary CSV file
    faux = auxpath(hash(scatter.data), figid, axidx)
    # don't rewrite if it's the exact same zipper
    isfile(faux) || csv_writer(faux, scatter.data, scatter.hasmissing)

    #
    # GLE syntax is:
    #
    #   data datafile.dat d1=c1,c2
    #   d1 line blue
    #

    for k ∈ 1:scatter.nobj
        # (1) indicate what data to read
        "\n\tdata \"$faux\" d$(el_cntr)=c1,c$(k+1)" |> g
        # if no color has been specified, assign one according to the PALETTE
        if !isdef(scatter.linestyles[k].color)
            cc = mod(el_cntr, GP_ENV["SIZE_PALETTE"])
            (cc == 0) && (cc = GP_ENV["SIZE_PALETTE"])
            scatter.linestyles[k].color = GP_ENV["PALETTE"][cc]
        end
        # (2) line and marker description
        # build a tuple with the current buffer and the legend entry buffer
        if scatter.linestyles[k].lstyle != -1
            # Line plot
            "\n\td$el_cntr" |> g
            "line" |> g; apply_linestyle!(g, scatter.linestyles[k])
            # if a marker color is specified and different than the line
            # color we need to have a special subroutine for GLE
            mcol = false
            if isdef(scatter.markerstyles[k].color) &&
                    (scatter.markerstyles[k].color != scatter.linestyles[k].color)
                mcol = true
                add_sub_marker!(Figure(figid; _noreset=true), scatter.markerstyles[k])
            end
            # apply markerstyle to the axes & the legend
            apply_markerstyle!(g, scatter.markerstyles[k], mcol=mcol)
        else
            # Scatter plot; if there's no specified marker color,
            # take the default line color
            if !isdef(scatter.markerstyles[k].color)
                scatter.markerstyles[k].color = scatter.linestyles[k].color
            end
            # apply markerstyle to the axes & legend
            "\n\td$el_cntr" |> g
            apply_markerstyle!(g, scatter.markerstyles[k])
        end
        el_cntr += 1
    end
    return el_cntr
end

####
#### Apply a Fill2D object
####

function apply_drawing!(g::GLE, fill::Fill2D, el_cntr::Int, figid::String, axidx::Int)
    # write data to a temporary CSV file
    faux = auxpath(hash(fill.data), figid, axidx)
    isfile(faux) || csv_writer(faux, fill.data, false)

    #
    # GLE syntax is:
    #
    #   data datafile.dat d1=c1,c2 d2=c1,c3
    #   fill d1,d2 color rgb(1,1,1) xmin 0 xmax 1
    #

    "\n\tdata \"$faux\" d$(el_cntr)=c1,c2 d$(el_cntr+1)=c1,c3" |> g
    "\n\tfill d$(el_cntr),d$(el_cntr+1)" |> g
    "color $(col2str(fill.fillstyle.fill))"    |> g
    isdef(fill.xmin) && "xmin $(fill.xmin)"    |> g
    isdef(fill.xmax) && "xmax $(fill.xmax)"    |> g

    el_cntr += 2
    return el_cntr
end

####
#### Apply a Hist2D object
####

function apply_drawing!(g::GLE, hist::Hist2D, el_cntr::Int, figid::String, axidx::Int)
    # write data to a temporary CSV file
    faux = auxpath(hash(hist.data), figid, axidx)
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
        if hist.barstyle.fill == c"white"
            cc = mod(el_cntr, GP_ENV["SIZE_PALETTE"])
            (cc == 0) && (cc = GP_ENV["SIZE_PALETTE"])
            hist.barstyle.color = GP_ENV["PALETTE"][cc]
        else
            hist.barstyle.color = c"white" # looks nicer than black
        end
    end

    # (1) indicate what data to read
    "\n\tdata \"$faux\" d$(el_cntr)" |> g

    # (2) hist description
    minx, maxx = hist.range
    "\n\tlet d$(el_cntr+1) = hist d$(el_cntr)" |> g
    "from $minx to $maxx" |> g
    el_cntr += 1

    # number of bins
    nobs = hist.nobs
    nbauto = (nobs == 0 ? 1 : ceil(Integer, log2(nobs))+1) # sturges, see StatsBase
    bins = isdef(hist.bins) ? hist.bins : nbauto
    "bins $bins" |> g

    # (3) compute appropriate scaling
    width   = (maxx - minx) / bins
    scaling = 1.0
    hist.scaling == "probability" && (scaling /= nobs)
    hist.scaling == "pdf"         && (scaling /= (nobs * width))
    "\n\tlet d$(el_cntr) = d$(el_cntr)*$scaling" |> g

    # (4) apply histogram
    "\n\tbar d$(el_cntr) width $width" |> g

    # apply styling
    apply_barstyle!(g, hist.barstyle)
    hist.horiz && "horiz" |> g

    return el_cntr+1
end

####
#### Apply Bar2D
####

function apply_drawing!(g::GLE, bar::Bar2D, el_cntr::Int, figid::String, axidx::Int)
    # write data to a temporary CSV file
    faux = auxpath(hash(bar.data), figid, axidx)
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
            if bar.barstyles[c].fill == c"white"
                cc = mod(el_cntr+c-1, GP_ENV["SIZE_PALETTE"])
                (cc == 0) && (cc = GP_ENV["SIZE_PALETTE"])
                bar.barstyles[c].color = GP_ENV["PALETTE"][cc]
            else
                bar.barstyles[c].color = c"white"
            end
        end
    end

    nbars = bar.nobj

    # (1) indicate what data to read "data file d1 d2 d3..."
    "\n\tdata \"$faux\"" |> g
    prod("d$(el_cntr+i-1) " for i ∈ (1:nbars)) |> g

    # (2) non stacked (or single barset)
    if nbars==1 || !bar.stacked
        # bar d1,d2,d3
        "\n\tbar $(svec2str(("d$(el_cntr+i-1)" for i ∈ 1:nbars)))" |> g
        isdef(bar.bwidth) && "width $(bar.bwidth)" |> g
        # apply bar styles
        apply_barstyles_nostack!(g, bar.barstyles)
        bar.horiz && "horiz" |> g

    # (2) stacked
    else
        # first base bar
        "\n\tbar d$(el_cntr)" |> g
        isdef(bar.bwidth) && "width $(bar.bwidth)" |> g
        apply_barstyle!(g, bar.barstyles[1])
        bar.horiz && "horiz" |> g
        # bars stacked on top
        for i ∈ 2:nbars
            "\n\tbar d$(el_cntr+i-1) from d$(el_cntr+i-2)" |> g
            apply_barstyle!(g, bar.barstyles[i])
        end
    end

    return el_cntr + nbars
end
