####
#### Ticks + TicksLabels
####

"""
    set_dist!(obj, v)

Internal function to set the vertical distance of `obj` to associated axis.
"""
set_dist!(o::Ticks, v::Float64) = (o.labels.dist = v)
set_dist!(o::Colorbar, v::Float64) = set_dist!(o.ticks, v)
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
set_length!(o::Ticks, v::Float64) = (o.length = v)
set_length!(o::Colorbar, v::Float64) = set_length!(o.ticks, v)

"""
    set_symticks!(obj, v)

Internal function to set the ticks to be symetric on both side of axis.
"""
set_symticks!(o::Ticks, v::Bool) = throw(NotImplementedError("set_symticks! for Ticks"))
set_symticks!(o::Colorbar, v::Bool) = throw(NotImplementedError("set_symticks! for Colorbar"))

"""
    set_grid!(obj, b)

Internal function to toggle the grid option of the `ticks` object.
"""
set_grid!(o::Ticks, b::Bool) = (o.grid = b)
set_grid!(o::Colorbar, v::Bool) = throw(NotImplementedError("set_symticks! for Colorbar"))

####
#### TicksLabels
####

"""
    set_angle!(obj, v)
Internal function to set the angle of display of ticks labels (in degrees).
"""
set_angle!(o::Ticks, v::Float64) = (o.labels.angle = v)
set_angle!(o::Colorbar, v::Float64) = throw(NotImplementedError("set_angle! for Colorbar"))

# a number format for tick labels
set_format!(o::Ticks, v::String) = throw(NotImplementedError("set_format! for Ticks"))
set_format!(o::Colorbar, v::String) = throw(NotImplementedError("set_format! for Colorbar"))

"""
    set_shift!(obj, v)

Internal function to set the horizontal shift for ticks.
"""
set_shift!(o::Ticks, v::Float64) = (o.labels.shift = v)
set_shift!(o::Colorbar, v::Float64) = set_shift!(o.ticks, v)

"""
    set_labels_off!(obj, v)

Internal function to hide the ticks labels.
"""
set_labels_off!(o::Ticks, v::Bool) = (o.labels.off = v)
set_labels_off!(o::Colorbar, v::Bool) = set_labels_off!(o.ticks, v)
