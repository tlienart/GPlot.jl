####
#### Legend
####

"""
   set_position!(legend, s)

Internal function to set the position of the legend using a describer like "tl" (top-left).
"""
function set_position!(o::Legend, v::String)
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
set_nobox!(o::Legend, b::Bool) = (o.nobox = b)

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

####
#### Ticks + TicksLabels
####

"""
    set_dist!(obj, v)

Internal function to set the vertical distance of `obj` to associated axis.
"""
set_dist!(o::Ticks, v::Float64) = (o.labels.dist = v)
set_dist!(o, v::Float64) = (o.dist = v)

"""
    set_off!(obj, v)

Internal function to set an object off.
"""
set_off!(o, v::Bool) = (o.off = v)

"""
    set_length!(obj, v)

Internal function to set the length of an object.
"""
set_length!(o::Ticks, v::Float64) = throw(NotImplementedError("set_length!"))

"""
    set_symticks!(obj, v)

Internal function to set the ticks to be symetric on both side of axis.
"""
set_symticks!(o::Ticks, v::Bool) = throw(NotImplementedError("set_symticks!"))

"""
    set_grid!(obj, b)

Internal function to toggle the grid option of the `ticks` object.
"""
set_grid!(o::Ticks, b::Bool) = (o.grid = b)

####
#### TicksLabels
####

"""
    set_angle!(obj, v)
Internal function to set the angle of display of ticks labels (in degrees).
"""
set_angle!(o::Ticks, v::Float64) = (o.labels.angle = v)

# a number format for tick labels
set_format!(o::Ticks, v::String) = throw(NotImplementedError("set_format!"))

"""
    set_shift!(obj, v)

Internal function to set the horizontal shift for ticks.
"""
set_shift!(o::Ticks, v::Float64) = (o.labels.shift = v)

"""
    set_labels_off!(obj, v)

Internal function to hide the ticks labels.
"""
set_labels_off!(o::Ticks, v::Bool) = (o.labels.off = v)
