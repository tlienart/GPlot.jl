"""
    set_pixels!(o, v)

Internal function to set the number of pixels used for a color-range.
"""
set_pixels!(o::Colorbar, v::Int) = (o.pixels = v)

function set_position!(o::Colorbar, v::String)
    v_lc = lowercase(v)
    v_lc ∈ ["left", "right", "top", "bottom"] || throw(ArgumentError("Unknown position value $v"))
    o.position = v
    return nothing
end

set_ticks!(o::Colorbar, v::Vector{Float64}) = (o.ticks.places = v; o.ticks.labels = TicksLabels())

function set_labels!(o::Colorbar, v::Vector{String})
    isempty(o.ticks.places) && throw(ArgumentError("You must specify the ticks position before " *
                                                   "the labels."))
    length(o.ticks.places) == length(v) || throw(ArgumentError("The dimensions of ticks places " *
                                                               "and labels don't match."))
    o.ticks.labels.names = v
    return nothing
end
