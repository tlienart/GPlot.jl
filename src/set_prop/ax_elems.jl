####
#### Ticks + TicksLabels
####

"""
    set_dist!(obj, v)

Internal function to set the vertical distance of `obj` to associated axis.
"""
function set_dist!(obj, v::Real)
   0 ≤ v || throw(OptionValueError("dist", v))
   if obj isa Ticks
      obj.labels.dist = v
   else
      obj.dist = v
   end
   return obj
end

"""
    set_off!(obj, v)

Internal function to set an object off.
"""
set_off!(obj::Ticks, v::Bool) = (obj.off = v; obj)

"""
    set_length!(obj, v)

Internal function to set the length of an object.
"""
set_length!(obj::Ticks, v::Real) = throw(NotImplementedError("set_length!"))

"""
    set_symticks!(obj, v)

Internal function to set the ticks to be symetric on both side of axis.
"""
set_symticks!(obj::Ticks, v::Bool) = throw(NotImplementedError("set_symticks!"))

"""
    set_tickscolor!(obj, v)

Internal function to set the color of ticks.
"""
set_tickscolor!(obj::Ticks, v::CandCol) = set_color!(obj, :linestyle, v)

####
#### TicksLabels
####

"""
    set_angle!(obj, v)

Internal function to set the angle of display of ticks labels.
"""
set_angle!(o::Ticks, v) = (o.labels.angle = float(v); o)

# a number format for tick labels
set_format!(o::Ticks, v::String) = throw(NotImplementedError("set_format!"))

# shift the tick labels (positive or negative)
set_shift!(o::Ticks, v::Real) = (o.labels.shift = v; o)

# hide ticks labels
set_labels_off!(o::Ticks, v::Bool) = (o.labels.off = v; o)
