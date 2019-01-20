function apply_drawings!(g::GLE, vd::Vector{Drawing})
    leg_entries = IOBuffer()
    el_cntr = 1
    for d ∈ vd
        el_cntr  = apply_drawing!(g, leg_entries, d, el_cntr)
        el_cntr += 1
    end
    return leg_entries
end


function apply_legend!(g::GLE, leg::Legend, leg_entries::IOBuffer)
    "\nbegin key"              |> g
    "\n\tcompact"              |> g
    isdef(leg.position) && "\n\tposition $(leg.position)" |> g
    isdef(leg.hei)      && "\n\thei $(leg.hei)"           |> g
#    "offset 0.2 0.2"   |> g
    String(take!(leg_entries)) |> g
    "\nend key"                |> g
    return
end

####
#### Apply a Line2D object
####

function apply_drawing!(g::GLE, leg_entries::IOBuffer, obj::Line2D, el_counter::Int=1)

    # temporary buffers to help for the legend
    lt   = [IOBuffer() for c ∈ 2:size(obj.xy, 2)]
    glet = GLE()

    # write data to a temporary CSV file
    faux = joinpath(GP_ENV["TMP_PATH"], gcf().id * "_auxdat_$el_counter.csv")
    writedlm(faux, obj.xy)

    # >>>>>>>>>>>>>>>>
    # general GLE syntax is:
    # (1) data datafile.dat d1=c1,c2  ! dataset out of the first two columns
    # (2) d1 line blue
    # <<<<<<<<<<<<<<<<

    for c ∈ eachindex(lt)
        # (1) indicate what data to read
        "\n\tdata \"$faux\" d$(el_counter)=c1,c$(c+1)" |> g

        # (2) line description
        "\n\td$el_counter" |> g
        if obj.linestyle.lstyle == -1 # no line
            lsc = obj.linestyle.color
            isdef(lsc) && "color $(col2str(lsc))" |> (g, lt[c])
        else
            "line" |> (g, lt[c])
            apply_linestyle!(glet, obj.linestyle)
            String(take!(glet)) |> (g, lt[c])
            # if marker color is specified, overlay a line with the markers
            # NOTE this is not recommended as it doesn't play well with legend!
            if isdef(obj.markerstyle.color)
                "\n\tlet d$(el_counter+1) = d$(el_counter)" |> g
                el_counter += 1
                "\n\td$el_counter" |> g
            end
        end
        # (2b) marker style
        apply_markerstyle!(glet, obj.markerstyle)
        String(take!(glet)) |> (g, lt[c])
        el_counter += 1
    end

    # (3) build legend
    if isdef(obj.label)
        if obj.label isa Vector{String}
            @assert length(obj.label) == length(lt)
            for c ∈ eachindex(lt)
                "\n\ttext \"$(obj.label[c])\"" |> leg_entries
                String(take!(lt[c]))           |> leg_entries
            end
        else # single string
            @assert length(lt) == 1 "Got several lines but a single label; " *
                                    "expected as many labels as lines."
            "\n\ttext \"$(obj.label)\"" |> leg_entries
            String(take!(lt[1]))        |> leg_entries
        end
    end

    return el_counter
end

####
#### Apply a Fill2D object
####

function apply_drawing!(g::GLE, ::IOBuffer, obj::Fill2D, el_counter::Int=1)

    # write data to a temporary CSV file
    faux = joinpath(GP_ENV["TMP_PATH"], gcf().id * "_auxdat_$el_counter.csv")
    writedlm(faux, obj.xy1y2)

    # >>>>>>>>>>>>>>>>
    # general GLE syntax is:
    # (1) data datafile.dat d1=c1,c2 d2=c1,c3
    # (2) fill d1,d2 color color_ xmin val xmax val
    # <<<<<<<<<<<<<<<<

    "\n\tdata \"$faux\" d$(el_counter)=c1,c2 d$(el_counter+1)=c1,c3" |> g
    "\n\tfill d$(el_counter),d$(el_counter+1)" |> g

    # color is not optional
    "color $(col2str(obj.fillstyle.color))" |> g

    isdef(obj.xmin) && "xmin $(obj.xmin)" |> g
    isdef(obj.xmax) && "xmax $(obj.xmax)" |> g

    el_counter += 2

    return el_counter
end

####
#### Apply a Hist2D object
####

function apply_drawing!(g::GLE, ::IOBuffer, obj::Hist2D, el_counter::Int=1)

    # # temporary buffers to help for the legend
    # lt   = IOBuffer()
    # glet = GLE()

    # write data to a temporary CSV file
    faux = joinpath(GP_ENV["TMP_PATH"], gcf().id * "_auxdat_$el_counter.csv")
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
#### Apply GroupedBar2D
####

function apply_drawing!(g::GLE, leg_entries::IOBuffer, obj::GroupedBar2D,
                        el_counter::Int=1)

    # write data to a temporary CSV file
    faux = joinpath(GP_ENV["TMP_PATH"], gcf().id * "_auxdat_$el_counter.csv")
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
        "\n\tbar $(svec2str(("d$(el_counter+i-1)," for i ∈ 1:nbars)))" |> g
        # apply bar styles
        apply_barstyles_nostack!(g, obj.barstyle)
        obj.horiz && "horiz" |> g

    # (2) stacked
    else
        # first base bar
        "\n\tbar d$(el_counter)" |> g
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
