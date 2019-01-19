####
#### Axis
####

function set_lims!(::Type{GLE}, o::Axis, min::Option{Real}, max::Option{Real})
    if min isa Real && max isa Real
        @assert min < max "min must be strictly smaller than max"
    end
    o.min = min
    o.max = max
    return o
end

function set_scale!(::Type{GLE}, o::Axis, v::String)
    name = get(GLE_AXSCALE, v) do
        throw(OptionValueError("scale", v))
    end
    o.log = ifelse(name=="log", true, false)
    return o
end

####
#### Axes2D
####

# uses a (0,0) centered axis (as opposed to bottom left)
set_math!(::Type{GLE}, o::Axes2D, v::Bool) = (o.math = ifelse(v, v, ∅); o)
