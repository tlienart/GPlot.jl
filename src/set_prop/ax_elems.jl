####
#### Ticks + TicksLabels
####

"""
    set_dist!(obj, v)

Internal function to set the vertical distance of `obj` to associated axis.
"""
set_dist!(o::Ticks, v::Float64) = (o.labels.dist = v; o)
set_dist!(o, v::Float64) = (o.dist = v; o)

"""
    set_off!(obj, v)

Internal function to set an object off.
"""
set_off!(o::Union{Ticks, Axis}, v::Bool) = (o.off = v; o)

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
    set_tickscolor!(obj, v)

Internal function to set the color of ticks.
"""
set_tickscolor!(o::Ticks, c::Color) = (o.linestyle.color = c; o)

"""
    set_grid!(obj, b)

Internal function to toggle the grid option of the `ticks` object.
"""
set_grid!(o::Ticks, b::Bool) = (o.grid = b; o)

####
#### TicksLabels
####

"""
    set_angle!(obj, v)

Internal function to set the angle of display of ticks labels.
"""
set_angle!(o::Ticks, v::Float64) = (o.labels.angle = v; o)

# a number format for tick labels
set_format!(o::Ticks, v::String) = throw(NotImplementedError("set_format!"))

"""
    set_shift!(obj, v)

Internal function to set the horizontal shift for ticks.
"""
set_shift!(o::Ticks, v::Float64) = (o.labels.shift = v; o)

"""
    set_labels_off!(obj, v)

Internal function to hide the ticks labels.
"""
set_labels_off!(o::Ticks, v::Bool) = (o.labels.off = v; o)
