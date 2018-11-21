function apply_drawing!(g::GLE, line::Line2D, el_counter::Int=1)
    faux = "$(GP_TMP_PATH)$(gcf().id)_auxdat_$el_counter.csv"
    writedlm(faux, line.xy)
    "\n\tdata \"$faux\" d$(el_counter)=c1,c2" |> g
    if line.linestyle.lstyle == -1 # no line
        "\n\td$el_counter" |> g
        lsc = line.linestyle.color
        isdef(lsc) && "color $(col2str(lsc))" |> g
    else
        "\n\td$el_counter line" |> g
        apply_linestyle!(g, line.linestyle)
        # if marker color is specified, overlay a line with the markers
        if isdef(line.markerstyle.color)
            "\n\tlet d$(el_counter+1) = d$(el_counter)" |> g
            el_counter = el_counter + 1
            "\n\td$el_counter"                          |> g
        end
    end
    apply_markerstyle!(g, line.markerstyle)
    return el_counter
end


function apply_drawings!(g::GLE, vd::Vector{Drawing})
    el_cntr = 1
    for d ∈ vd
        el_cntr = apply_drawing!(g, d, el_cntr)
        el_cntr += 1
    end
    return g
end
