####
#### Axis
####
function set_scale!(a::Axis, v::String)
    a.log = get(GLE_AXSCALE, v) do
        throw(OptionValueError("axis scale", v))
    end
    return a
end

####
#### Axes2D
####

# uses a (0,0) centered axis (as opposed to bottom left)
set_math!(::Type{GLE}, o::Axes2D, v::Bool) = (o.math = ifelse(v, v, ∅); o)
