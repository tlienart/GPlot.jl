function apply_drawing!(g::GLE, line::Line2D, el_counter::Int=1)
    faux = "$GP_TMP_PATH/$(get_curfig().id)_auxdat_$el_counter.csv"
    writedlm(faux, line.xy)
    "\n\tdata \"$faux\""    |> g
    "\n\td$el_counter line" |> g
    isdef(line.linestyle)   && apply_linestyle!(g, line.linestyle)
    isdef(line.markerstyle) && apply_markerstyle!(g, line.markerstyle)
    return g
end


function apply_drawings!(g::GLE, vd::Vector{Drawing})
    el_cntr = 1
    for d ∈ vd
        apply_drawing!(g, d, el_cntr)
        el_cntr += 1
    end
    return g
end
