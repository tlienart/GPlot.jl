####
#### Ticks + TicksLabels
####

# vertical distance of text to axis
function set_dist!(obj, v::Real)
   0 ≤ v || throw(OptionValueError("dist", v))
   obj.dist = v
   return obj
end
set_dist!(obj::Ticks, v::Real) = set_dist!(obj.labels, v)

set_off!(o::Ticks, v::Bool) = (o.off = v; o)

set_length!(o, v::Real) = throw(NotImplementedError("set_length!"))

set_symticks!(o, v::Bool) = throw(NotImplementedError("set_symticks!"))

set_tickscolor!(o::Ticks, v) = set_color!(o, :linestyle, v)

####
#### TicksLabels
####

# rotation angle of tick labels XXX in what unit??
set_angle!(o::Ticks, v::Real) = (o.labels.angle = v; o)

# a number format for tick labels
set_format!(o::Ticks, v::String) = throw(NotImplementedError("set_format!"))

# shift the tick labels (positive or negative)
set_shift!(o::Ticks, v::Real) = (o.labels.shift = v; o)

# hide ticks labels
set_labels_off!(o::Ticks, v::Bool) = (o.labels.off = v; o)
