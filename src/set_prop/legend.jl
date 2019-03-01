"""
   set_position!(legend, s)

Internal function to set the position of the legend using a describer like "tl" (top-left).
"""
function set_position!(o::Union{Legend,Box2D}, v::String)
   @assert get_backend() == GLE "position/only GLE backend supported"
   o.position = get(GLE_POSITION, v) do
      throw(OptionValueError("position", v))
   end
   return nothing
end

"""
   set_nobox!(legend, b)

Internal function to toggle nobox on or off for the legend.
"""
set_nobox!(o::Union{Legend,Box2D}, b::Bool) = (o.nobox = b)

"""
   set_margins!(legend, m)

Internal function to set the margins of the legend (internal distance from legend box to elements).
"""
set_margins!(o::Legend, m::T2F) = (o.margins = m)

"""
   set_offset!(legend, m)

Internal function to set the offset of the legend (external distance from legend box to its
position anchor.
"""
set_offset!(o::Legend, v::T2F) = (o.offset = v)
