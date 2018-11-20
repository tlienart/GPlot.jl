function set_text!(::GLE, obj, elem, v)
   v isa String || throw(OptionValueError("text", v))
   setfield!(getfield(obj, elem), :text, v)
   return
end

set_text!(g, e::Title, v) = set_text!(g, e, :title, v)

function set_prefix!(::GLE, obj, elem, v)
   v isa String || throw(OptionValueError("prefix", v))
   v = lowercase(v)
   v ∈ ["x", "x2", "y", "y2", "z"] || throw(OptionValueError("prefix", v))
   setfield!(getfield(obj, elem), :prefix, v)
   return
end

# --------------------
# TITLE
# --------------------
