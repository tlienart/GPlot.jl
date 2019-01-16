function set_text!(::Type{GLE}, obj, elem, v)
   v isa AbstractString || throw(OptionValueError("text", v))
   setfield!(getfield(obj, elem), :text, v)
   return
end
set_text!(g, e::Title, v) = set_text!(g, e, :title, v)


function set_prefix!(::Type{GLE}, obj, v)
   v isa String || throw(OptionValueError("prefix", v))
   v = lowercase(v)
   v ∈ ["x", "x2", "y", "y2", "z"] || throw(OptionValueError("prefix", v))
   v.prefix = v
   return
end


# switch something on or off
function set_off!(::Type{GLE}, obj, v)
   v isa Bool || throw(OptionValueError("off", v))
   obj.off = v
end


# vertical distance of text to axis
function set_dist!(::Type{GLE}, obj, v)
   ((v isa Real) && v ≥ 0.) || throw(OptionValueError("dist", v))
   obj.dist = v
   return
end

####
#### TicksLabels
####

# rotation angle of tick labels
function set_angle!(::Type{GLE}, obj, v)
   (v isa Real) || throw(OptionValueError("angle", v))
   obj.angle = v
   return
end


# a number format for tick labels
function set_format!(::Type{GLE}, obj, v)
   throw(NotImplementedError("GLE/set_format!"))
end


# shift the tick labels (positive or negative)
function set_shift(::Type{GLE}, obj, v)
   (v isa Real) ||  throw(OptionValueError("shift", v))
   obj.shift = v
   return
end


# set tick labels
function set_names!(::Type{GLE}, obj, v)
   (v isa Vector{<:AbstractString}) || throw(OptionValueError("names", v))
   obj.names = v
   return
end
