function apply_drawing!(g::GLE, leg_entries::IOBuffer, line::Line2D, el_counter::Int=1)
    lt   = IOBuffer() # temporary for legend entry
    glet = GLE()
    # write data
    faux = joinpath(GP_TMP_PATH, gcf().id * "_auxdat_$el_counter.csv")
    writedlm(faux, line.xy)
    # indicate what data to read
    "\n\tdata \"$faux\" d$(el_counter)=c1,c2" |> g
    # line description
    "\n\td$el_counter" |> g
    if line.linestyle.lstyle == -1 # no line
        lsc = line.linestyle.color
        isdef(lsc) && "color $(col2str(lsc))" |> (g, lt)
    else
        "line" |> g
        apply_linestyle!(glet, line.linestyle)
        String(take!(glet)) |> (g, lt)
        # if marker color is specified, overlay a line with the markers
        # NOTE this is not recommended as it doesn't play well with legend!
        if isdef(line.markerstyle.color)
            "\n\tlet d$(el_counter+1) = d$(el_counter)" |> g
            el_counter = el_counter + 1
            "\n\td$el_counter"                          |> g
        end
    end
    apply_markerstyle!(glet, line.markerstyle)
    String(take!(glet)) |> (g, lt)
    if isdef(line.label)
        "\n\ttext \"$(line.label)\"" |> leg_entries
        String(take!(lt))            |> leg_entries
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
#    "offset 0.2 0.2"   |> g
    String(take!(leg_entries)) |> g
    "\nend key"                |> g
end
