####
#### [x|y]lim, [x|y]lim! (synonyms though with ! is preferred)
####

function _lim!(a::Option{Axes2D}, el::Symbol, min::Option{Real},
               max::Option{Real})

    isnothing(a) && (add_axes2d!(); a=gca())
    if min isa Real && max isa Real
        @assert min < max "min must be strictly smaller than max"
    end
    axis = getfield(a, el)
    setfield!(axis, :min, float(min))
    setfield!(axis, :max, float(max))
    return a
end

# Generate xlim!, xlim, and associated for each axis
for axs ∈ ["x", "y", "x2", "y2"]
    f! = Symbol(axs * "lim!")
    f  = Symbol(axs * "lim")
    ex = quote
        $f!(a, min, max)    = _lim!(a, Symbol($axs * "axis"), min, max)
        $f!(min, max)       = $f!(gca(), min, max)
        $f!(; min=∅, max=∅) = $f!(gca(), min, max)
        # synonyms
        $f(a, min, max)    = $f!(a, min, max)
        $f(min, max)       = $f!(gca(), min, max)
        $f(; min=∅, max=∅) = $f!(gca(), min, max)
    end
    eval(ex)
end

####
#### [x|y]lim, [x|y]lim! (synonyms though with ! is preferred)
####
function _scale!(a::Axis, v::String)
    a.log = get(AXSCALE, v) do
        throw(OptionValueError("axis scale", v))
    end
    return a
end

# Generate xscale!, xscale, and associated for each axis
for axs ∈ ["x", "y", "x2", "y2"]
    f! = Symbol(axs * "scale!")       # xscale!
    f  = Symbol(axs * "scale")        # xscale
    ex = quote
        $f!(a::Axes2D, v) = _scale!(getfield(a, Symbol($axs * "axis")), v)
        $f!(::Nothing, v) = $f!(add_axes2d!(), v)
        $f!(v)            = $f!(gca(), v)
        # synonyms
        $f(a, v) = $f!(a, v)
        $f(v)    = $f!(gca(), v)
    end
    eval(ex)
end
