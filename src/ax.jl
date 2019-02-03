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

xlim!(a, min, max)    = _lim!(a, :xaxis, min, max)
xlim!(min, max)       = xlim!(gca(), min, max)
xlim!(; min=∅, max=∅) = xlim!(gca(), min, max)

# SYNONYMS
xlim(a, min, max)    = xlim!(a, min, max)
xlim(min, max)       = xlim!(gca(), min, max)
xlim(; min=∅, max=∅) = xlim!(gca(), min, max)

x2lim!(a, min, max)    = _lim!(a, :x2axis, min, max)
x2lim!(min, max)       = x2lim!(gca(), min, max)
x2lim!(; min=∅, max=∅) = x2lim!(gca(), min, max)

# SYNONYMS
x2lim(a, min, max)    = x2lim!(a, min, max)
x2lim(min, max)       = x2lim!(gca(), min, max)
x2lim(; min=∅, max=∅) = x2lim!(gca(), min, max)

ylim!(a, min, max)    = _lim!(a, :yaxis, min, max)
ylim!(min, max)       = ylim!(gca(), min, max)
ylim!(; min=∅, max=∅) = ylim!(gca(), min, max)

# SYNONYMS
ylim(a, min, max)    = ylim!(a, min, max)
ylim(min, max)       = ylim!(gca(), min, max)
ylim(; min=∅, max=∅) = ylim!(gca(), min, max)

y2lim!(a, min, max)    = _lim!(a, :y2axis, min, max)
y2lim!(min, max)       = y2lim!(gca(), min, max)
y2lim!(; min=∅, max=∅) = y2lim!(gca(), min, max)

# SYNONYMS
y2lim(a, min, max)    = y2lim!(a, min, max)
y2lim(min, max)       = y2lim!(gca(), min, max)
y2lim(; min=∅, max=∅) = y2lim!(gca(), min, max)


####
#### [x|y]lim, [x|y]lim! (synonyms though with ! is preferred)
####
function _scale!(a::Axis, v::String)
    a.log = get(AXSCALE, v) do
        throw(OptionValueError("axis scale", v))
    end
    return a
end

xscale!(a::Axes2D, v::String) = _scale!(a.xaxis, v)
xscale(a::Axes2D, v::String)  = _scale!(a.xaxis, v)

xscale!(v) = xscale!(gca(), v)
xscale(v)  = xscale!(gca(), v)

x2scale!(a::Axes2D, v::String) = _scale!(a.x2axis, v)
x2scale(a::Axes2D, v::String)  = _scale!(a.x2axis, v)

x2scale!(v) = x2scale!(gca(), v)
x2scale(v)  = x2scale!(gca(), v)

yscale!(a::Axes2D, v::String) = _scale!(a.yaxis, v)
yscale(a::Axes2D, v::String)  = _scale!(a.yaxis, v)

yscale!(v) = yscale!(gca(), v)
yscale(v)  = yscale!(gca(), v)

y2scale!(a::Axes2D, v::String) = _scale!(a.y2axis, v)
y2scale(a::Axes2D, v::String)  = _scale!(a.y2axis, v)

y2scale!(v) = y2scale!(gca(), v)
y2scale(v)  = y2scale!(gca(), v)

xscale!(a::Nothing,  v::String) = (add_axes2d!(); _scale!(gca().xaxis, v))
x2scale!(a::Nothing, v::String) = (add_axes2d!(); _scale!(gca().x2axis, v))
yscale!(a::Nothing,  v::String) = (add_axes2d!(); _scale!(gca().yaxis, v))
y2scale!(a::Nothing, v::String) = (add_axes2d!(); _scale!(gca().y2axis, v))
