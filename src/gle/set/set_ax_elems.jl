set_text!(::Type{GLE}, obj, el, v::AS) = setfield!(getfield(obj, el), :text, v)
set_text!(g, e::Title, v) = set_text!(g, e, :title, v)


function set_prefix!(::Type{GLE}, obj, v::AS)
   v = lowercase(v)
   v ∈ ["x", "x2", "y", "y2", "z"] || throw(OptionValueError("prefix", v))
   v.prefix = v
end


# switch something on or off
set_off!(::Type{GLE}, obj, v::Bool) = (obj.off = v)

# vertical distance of text to axis
function set_dist!(::Type{GLE}, obj, v::Real)
   (v ≥ 0.) || throw(OptionValueError("dist", v))
   obj.dist = v
end

####
#### TicksLabels
####

# rotation angle of tick labels
set_angle!(::Type{GLE}, obj, v::Real) = (obj.angle = v)

# a number format for tick labels
set_format!(::Type{GLE}, obj, v) = throw(NotImplementedError("GLE/set_format!"))

# shift the tick labels (positive or negative)
set_shift(::Type{GLE}, obj, v::Real) = (obj.shift = v)

# set tick labels
set_names!(::Type{GLE}, obj, v::Vector{<:AS}) = (obj.names = v)
