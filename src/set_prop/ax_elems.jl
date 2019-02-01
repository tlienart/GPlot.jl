####
#### Ticks + TicksLabels
####

# vertical distance of text to axis
function set_dist!(o::Union{Title,Ticks}, v::Real)
   (v ≥ 0) || throw(OptionValueError("dist", v))
   o.dist = v
   return o
end

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
set_shift(o::Ticks, v::Real) = (o.shift = v; o)

# hide ticks labels
set_labels_off!(o::Ticks, v::Bool) = set_off!(g, o.labels, v)

set_shift!(o::Ticks, v::Real) = throw(NotImplementedError("set_shift!"))
