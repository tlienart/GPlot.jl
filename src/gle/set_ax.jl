####
#### Axes2D
####

# uses a (0,0) centered axis (as opposed to bottom left)
function set_math!(::Type{GLE}, obj, v)
   (v isa Bool) || throw(OptionValueError("math", v))
   obj.math = ifelse(v, true, nothing)
   return
end
