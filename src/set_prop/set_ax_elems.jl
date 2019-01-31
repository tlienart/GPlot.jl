set_text!(::TBK, o, el, v::AS) = (setfield!(getfield(o, el), :text, v); o)
set_text!(g, e::Title, v) = set_text!(g, e, :title, v)

####
#### Ticks
####

function set_prefix!(::TBK, o, v::AS)
   v = lowercase(v)
   v ∈ ["x", "x2", "y", "y2", "z"] || throw(OptionValueError("prefix", v))
   o.prefix = v
   return o
end

# switch something on or off
set_off!(::TBK, o, v::Bool) = (obj.off = v; o)

# vertical distance of text to axis
function set_dist!(::TBK, o, v::Real)
   (v ≥ 0.) || throw(OptionValueError("dist", v))
   o.dist = v
   return o
end

set_length!(::TBK, o, v) = throw(NotImplementedError("set_length!"))

set_symticks!(::TBK, o, v) = throw(NotImplementedError("set_symticks!"))

####
#### TicksLabels
####

# rotation angle of tick labels
set_angle!(::TBK, o, v::Real) = (o.angle = v; o)

# a number format for tick labels
set_format!(::TBK, o, v) = throw(NotImplementedError("set_format!"))

# shift the tick labels (positive or negative)
set_shift(::TBK, o, v::Real) = (o.shift = v; o)

# set tick labels
set_names!(::TBK, o, v::Vector{<:AS}) = (o.names = v; o)

# hide ticks labels
set_labels_off!(::TBK, o::Ticks, v::Bool) = set_off!(g, o.labels, v)

#
set_shift!(::TBK, o, v) = throw(NotImplementedError("set_shift!"))
