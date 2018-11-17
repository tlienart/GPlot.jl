function apply_markers!(g::GLE, m::Markers)
    "marker $(m.marker)" |> g
    isdef(m.msize) && "msize $(m.msize)"          |> g
    isdef(m.color) && gle_no_support("setting the marker face color.")
    return g
end


function apply_drawing!(g::GLE, line::Line2D, el_counter::Int=1)
    "\n\td$el_counter" |> g
    isdef(line.lstyle)  && apply_linestyle!(g, line.lstyle)
    isdef(line.markers) && apply_markers!(g, line.markers)
    return g
end

#function apply_drawing!(g::GLE, hist::Hist, el_counter::Int=1)

function apply_drawings!(g::GLE, vd::Vector{Drawing})
    el_cntr = 1
    for d ∈ vd
        apply_drawing!(g, d, el_cntr)
        el_cntr += 1
    end
    return g
end
