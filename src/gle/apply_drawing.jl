function apply_drawing!(g::GLE, leg_entries::IOBuffer, obj::Line2D, el_counter::Int=1)

    # temporary buffers to help for the legend
    lt   = [IOBuffer() for c ∈ 2:size(obj.xy, 2)]
    glet = GLE()

    # write data to a temporary CSV file
    faux = joinpath(GP_TMP_PATH, gcf().id * "_auxdat_$el_counter.csv")
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
                el_counter = el_counter + 1
                "\n\td$el_counter"                          |> g
            end
        end
        # (2b) marker style
        apply_markerstyle!(glet, obj.markerstyle)
        String(take!(glet)) |> (g, lt[c])
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
end
