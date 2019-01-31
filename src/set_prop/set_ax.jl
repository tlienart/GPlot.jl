####
#### Axes2D
####

# uses a (0,0) centered axis (as opposed to bottom left)
set_math!(::TBK, o::Axes2D, v::Bool) = (o.math = ifelse(v, v, ∅); o)
