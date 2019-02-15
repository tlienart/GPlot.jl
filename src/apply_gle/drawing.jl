"""
    apply_drawings!(g, drawings, axorigin, figid)

Internal function to apply a vector of `Drawing` objects contained in an `Axes`
container in a GLE context. The `axorigin` and `figid` help keep track of
where individual drawings belong to which is useful when writing auxiliary files
containing the drawing data.
"""
function apply_drawings!(g::GLE, drawings::Vector{Drawing},
                         axorigin::NTuple{2,Float64}, figid::String)
    leg_entries = IOBuffer()
    # element counter to have an index over objects drawn
    el_cntr = 1
    for drawing ∈ drawings
        el_cntr  = apply_drawing!(g, leg_entries, drawing, el_cntr, axorigin, figid)
        el_cntr += 1
    end
    # this is recuperated in apply_axes for further processing by apply_legend!
    return leg_entries
end

"""
    apply_legend!(g, leg, entries)

Internal function to apply a `Legend` object `leg` in a GLE context with entries
`entries` (constructed through the `apply_drawings` process).
"""
function apply_legend!(g::GLE, leg::Legend, entries::IOBuffer)
    "\nbegin key"              |> g
    "\n\tcompact"              |> g
    isdef(leg.position) && "\n\tposition $(leg.position)" |> g
    isdef(leg.hei)      && "\n\thei $(leg.hei)"           |> g
#    "offset 0.2 0.2"   |> g
    String(take!(entries)) |> g
    "\nend key"            |> g
    return
end

####
#### Apply a Scatter2D object
####

"""
    auxpath(number)

Internal function to generate a path to an auxiliary file storing drawing data for the current
axes of the current figure.
"""
function auxpath(n::Int, origin::NTuple{2,Float64}, figid::String)
    path = GP_ENV["TMP_PATH"]
    axid = isdef(origin) ? "$(origin[1])_$(origin[2])" : ""
    return joinpath(path, "$(figid)_$(axid)_d$n.csv")
end

"""
    apply_drawing!(g, leg_entries, obj, el_counter, origin, figid)

Internal function to apply a `Drawing` object `obj` in a GLE context `g` with current
legend entries `leg_entries` (possibly empty), current element counter `el_counter`
and `origin` and `figid` are used to make the auxiliary file name unique.
"""
function apply_drawing!(g::GLE, leg_entries::IOBuffer, obj::Scatter2D,
                        el_counter::Int, origin::NTuple{2,Float64}, figid::String)
    # temporary buffers to help for the legend
    lt   = [IOBuffer() for c ∈ 2:size(obj.xy, 2)]
    glet = GLE()

    # write data to a temporary CSV file
    faux = auxpath(el_counter, origin, figid)
    csv_writer(faux, obj.xy)

    # >>>>>>>>>>>>>>>>
    # general GLE syntax is:
    # (1) data datafile.dat d1=c1,c2  ! dataset out of the first two columns
    # (2) d1 line blue
    # <<<<<<<<<<<<<<<<

    for c ∈ eachindex(lt)
        # (1) indicate what data to read
        "\n\tdata \"$faux\" d$(el_counter)=c1,c$(c+1)" |> g

        # if no color has been specified, assign one according to the PALETTE
        if !isdef(obj.linestyle[c].color)
            # assumes 10 colors in color palette
            cc = mod(el_counter, GP_ENV["SIZE_PALETTE"])
            (cc == 0) && (cc = 10)
            obj.linestyle[c].color = GP_ENV["PALETTE"][cc]
        end
        # (2) line description
        "\n\td$el_counter" |> g
        if obj.linestyle[c].lstyle == -1 # no line
            "color $(col2str(obj.linestyle[c].color))" |> (g, lt[c])
        else
            "line" |> (g, lt[c])
            apply_linestyle!(g, obj.linestyle[c])
            apply_linestyle!(glet, obj.linestyle[c], legend=true)
            String(take!(glet)) |> lt[c]
            # XXX if marker color is specified, overlay a line with the markers
            # NOTE this is not recommended as it doesn't play well with legend!
            if isdef(obj.markerstyle[c].color)
                "\n\tlet d$(el_counter+1) = d$(el_counter)" |> g
                el_counter += 1
                "\n\td$el_counter" |> g
            end
        end
        # (2b) marker style
        apply_markerstyle!(glet, obj.markerstyle[c])
        String(take!(glet)) |> (g, lt[c])
        el_counter += 1
    end

    # (3) build legend entries (will be applied if a legend command is issued)
    if isempty(obj.label)
        offset = length(lt)
        for c ∈ eachindex(lt)
            "\n\ttext \"plot $(el_counter-offset-1+c)\"" |> leg_entries
            String(take!(lt[c])) |> leg_entries
        end
    else
        for c ∈ eachindex(lt)
            "\n\ttext \"$(obj.label[c])\"" |> leg_entries
            String(take!(lt[c])) |> leg_entries
        end
    end

    return el_counter
end

####
#### Apply a Fill2D object
####

function apply_drawing!(g::GLE, leg_entries::IOBuffer, obj::Fill2D,
                        el_counter::Int, origin::NTuple{2,Float64}, figid::String)

    # write data to a temporary CSV file
    faux = auxpath(el_counter, origin, figid)
    writedlm(faux, obj.xy1y2)

    # >>>>>>>>>>>>>>>>
    # general GLE syntax is:
    # (1) data datafile.dat d1=c1,c2 d2=c1,c3
    # (2) fill d1,d2 color color_ xmin val xmax val
    # <<<<<<<<<<<<<<<<

    "\n\tdata \"$faux\" d$(el_counter)=c1,c2 d$(el_counter+1)=c1,c3" |> g
    "\n\tfill d$(el_counter),d$(el_counter+1)" |> g

    # color is not optional
    "color $(col2str(obj.fillstyle.fill))" |> g

    isdef(obj.xmin) && "xmin $(obj.xmin)" |> g
    isdef(obj.xmax) && "xmax $(obj.xmax)" |> g

    el_counter += 2

    return el_counter
end

####
#### Apply a Hist2D object
####

function apply_drawing!(g::GLE, leg_entries::IOBuffer, obj::Hist2D,
                        el_counter::Int, origin::NTuple{2,Float64}, figid::String)

    # # temporary buffers to help for the legend
    # lt   = IOBuffer()
    # glet = GLE()

    # write data to a temporary CSV file
    faux = auxpath(el_counter, origin, figid)
    writedlm(faux, obj.x)

    # >>>>>>>>>>>>>>>>
    # general GLE syntax is:
    # (1) data datafile.dat d1
    # (2) let d2 = hist d1 from xmin to xmax bins nbins
    # (3) let d2 = d2 * scaling
    # (4) bar d2 width width_ fill color_ color color_ pattern pattern_ horiz
    # <<<<<<<<<<<<<<<<

    # (1) indicate what data to read
    "\n\tdata \"$faux\" d$(el_counter)" |> g

    # (2) hist description
    minx, maxx = minimum(obj.x), maximum(obj.x)
    "\n\tlet d$(el_counter+1) = hist d$(el_counter)" |> g
    "from $minx to $maxx" |> g
    el_counter += 1

    # number of bins (TODO: better criterion, see StatsPlots.jl)
    nobs   = length(obj.x)
    nbauto = (nobs<10) * nobs +
             (10<=nobs<30) * 10 +
             (nobs>30) * min(round(Int, sqrt(nobs)), 150)
    bins   = isdef(obj.bins) ? obj.bins : nbauto
    "bins $bins" |> g

    # (3) compute appropriate scaling
    width   = (maxx - minx) / bins
    scaling = 1.0
    obj.scaling == "probability" && (scaling /= nobs)
    obj.scaling == "pdf"         && (scaling /= (nobs * width))
    "\n\tlet d$(el_counter) = d$(el_counter)*$scaling" |> g

    # (4) apply histogram
    "\n\tbar d$(el_counter) width $width" |> g

    # apply styling
    apply_barstyle!(g, obj.barstyle)
    obj.horiz && "horiz" |> g

    return el_counter
end

####
#### Apply Bar2D
####

function apply_drawing!(g::GLE, leg_entries::IOBuffer, obj::Bar2D,
                        el_counter::Int, origin::NTuple{2,Float64}, figid::String)

    # write data to a temporary CSV file
    faux = auxpath(el_counter, origin, figid)
    writedlm(faux, obj.xy)

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

    nbars = size(obj.xy, 2) - 1

    # (1) indicate what data to read "data file d1 d2 d3..."
    "\n\tdata \"$faux\"" |> g
    prod("d$(el_counter+i-1) " for i ∈ (1:nbars)) |> g

    # (2) non stacked (or single barset)
    if nbars==1 || !obj.stacked
        # bar d1,d2,d3
        "\n\tbar $(svec2str(("d$(el_counter+i-1)" for i ∈ 1:nbars)))" |> g
        isdef(obj.width) && "width $(obj.width)" |> g
        # apply bar styles
        apply_barstyles_nostack!(g, obj.barstyle)
        obj.horiz && "horiz" |> g

    # (2) stacked
    else
        # first base bar
        "\n\tbar d$(el_counter)" |> g
        isdef(obj.width) && "width $(obj.width)" |> g
        apply_barstyle!(g, obj.barstyle[1])
        obj.horiz && "horiz" |> g
        # bars stacked on top
        for i ∈ 2:nbars
            "\n\tbar d$(el_counter+i-1) from d$(el_counter+i-2)" |> g
            apply_barstyle!(g, obj.barstyle[i])
        end
    end

    return el_counter + nbars
end
