####
#### Axes2D
####

# uses a (0,0) centered axis (as opposed to bottom left)
set_math!(::Type{GLE}, obj, v::Bool) = (obj.math = ifelse(v, v, ∅))
