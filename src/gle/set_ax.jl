function set_text!(::Type{GLE}, obj, elem, v)
   v isa String || throw(OptionValueError("text", v))
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

function set_off!(::Type{GLE}, obj, v)
   v isa Bool || throw(OptionValueError("off", v))
   obj.off = v
end

function set_dist!(::Type{GLE}, obj, v)
   ((v isa Real) && v ≥ 0.) || throw(OptionValueError("prefix", v))
   obj.dist = v
   return
end

function set_size!(::Type{GLE}, obj, v)
   (v isa Tuple{<:Real, <:Real}) || throw(OptionValueError("size", v))
   w, h = v
   (w ≥ 0.) && (h ≥ 0.) || throw(OptionValueError("prefix", v))
   obj.size = v
end

# --------------------
# TITLE specific: none
# --------------------

# --------------------
# TICKSLABELS specific
# --------------------

function set_angle!(::Type{GLE}, obj, v)
   (v isa Real) || throw(OptionValueError("prefix", v))
   obj.angle = v
   return
end

function set_format!(::Type{GLE}, obj, v)
   throw(NotImplementedError("GLE/set_format!"))
end

function set_shift(::Type{GLE}, obj, v)
   (v isa Real) ||  throw(OptionValueError("prefix", v))
   obj.shift = v
   return
end

function set_names!(::Type{GLE}, obj, v)
   (v isa Vector{String}) || throw(OptionValueError("names", v))
   obj.names = v
   return
end

# --------------------
# AXES2D specific
# --------------------

function set_math!(::Type{GLE}, obj, v)
   (v isa Bool) || throw(OptionValueError("math", v))
   obj.math = ifelse(v, true, nothing)
   return
end
