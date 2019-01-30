set_text!(::Type{GLE}, o, el, v::AS) = (setfield!(getfield(o, el), :text, v); o)
set_text!(g, e::Title, v) = set_text!(g, e, :title, v)

####
#### Ticks
####

function set_prefix!(::Type{GLE}, o, v::AS)
   v = lowercase(v)
   v ∈ ["x", "x2", "y", "y2", "z"] || throw(OptionValueError("prefix", v))
   o.prefix = v
   return o
end

# switch something on or off
set_off!(::Type{GLE}, o, v::Bool) = (obj.off = v; o)

# vertical distance of text to axis
function set_dist!(::Type{GLE}, o, v::Real)
   (v ≥ 0.) || throw(OptionValueError("dist", v))
   o.dist = v
   return o
end

set_length!(::Type{GLE}, o, v) = throw(NotImplementedError("GLE/set_length!"))

set_symticks!(::Type{GLE}, o, v) = throw(NotImplementedError("GLE/set_symticks!"))

####
#### TicksLabels
####

# rotation angle of tick labels
set_angle!(::Type{GLE}, o, v::Real) = (o.angle = v; o)

# a number format for tick labels
set_format!(::Type{GLE}, o, v) = throw(NotImplementedError("GLE/set_format!"))

# shift the tick labels (positive or negative)
set_shift(::Type{GLE}, o, v::Real) = (o.shift = v; o)

# set tick labels
set_names!(::Type{GLE}, o, v::Vector{<:AS}) = (o.names = v; o)

# hide ticks labels
set_labels_off!(g::Type{GLE}, o::Ticks, v::Bool) = set_off!(g, o.labels, v)

#
set_shift!(::Type{GLE}, o, v) = throw(NotImplementedError("GLE/set_shift!"))
