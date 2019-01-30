####
#### [x|y]lim, [x|y]lim! (synonyms though with ! is preferred)
####

function _lim!(axes::Axes2D, el::Symbol, min::Option{Real},
               max::Option{Real})

    if min isa Real && max isa Real
        @assert min < max "min must be strictly smaller than max"
    end
    axis = getfield(axes, el)
    setfield!(axis, :min, min)
    setfield!(axis, :max, max)
    return
end

xlim!(a::Axes2D, min, max) = _lim!(a, :xaxis, min, max)
xlim!(min, max)            = xlim!(gca(), min, max)
xlim!(; min=∅, max=∅)      = xlim!(gca(), min, max)

# SYNONYMS
xlim(a::Axes2D, min, max) = xlim!(a, min, max)
xlim(min, max)            = xlim!(gca(), min, max)
xlim(; min=∅, max=∅)      = xlim!(gca(), min, max)

x2lim!(a::Axes2D, min, max) = _lim!(a, :x2axis, min, max)
x2lim!(min, max)            = x2lim!(gca(), min, max)
x2lim!(; min=∅, max=∅)      = x2lim!(gca(), min, max)

# SYNONYMS
x2lim(a::Axes2D, min, max) = x2lim!(a, min, max)
x2lim(min, max)            = x2lim!(gca(), min, max)
x2lim(; min=∅, max=∅)      = x2lim!(gca(), min, max)

ylim!(a::Axes2D, min, max) = _lim!(a, :yaxis, min, max)
ylim!(min, max)            = ylim!(gca(), min, max)
ylim!(; min=∅, max=∅)      = ylim!(gca(), min, max)

# SYNONYMS
ylim(a::Axes2D, min, max) = ylim!(a, min, max)
ylim(min, max)            = ylim!(gca(), min, max)
ylim(; min=∅, max=∅)      = ylim!(gca(), min, max)

y2lim!(a::Axes2D, min, max) = _lim!(a, :y2axis, min, max)
y2lim!(min, max)            = y2lim!(gca(), min, max)
y2lim!(; min=∅, max=∅)      = y2lim!(gca(), min, max)

# SYNONYMS
y2lim(a::Axes2D, min, max) = y2lim!(a, min, max)
y2lim(min, max)            = y2lim!(gca(), min, max)
y2lim(; min=∅, max=∅)      = y2lim!(gca(), min, max)


####
#### [x|y]lim, [x|y]lim! (synonyms though with ! is preferred)
####

xscale!(a::Axes2D, v::String) = set_scale!(a.xaxis, v)
xscale(a::Axes2D, v::String)  = set_scale!(a.xaxis, v)

xscale!(v) = xscale!(gca(), v)
xscale(v)  = xscale!(gca(), v)

x2scale!(a::Axes2D, v::String) = set_scale!(a.x2axis, v)
x2scale(a::Axes2D, v::String)  = set_scale!(a.x2axis, v)

x2scale!(v) = x2scale!(gca(), v)
x2scale(v)  = x2scale!(gca(), v)

yscale!(a::Axes2D, v::String) = set_scale!(a.yaxis, v)
yscale(a::Axes2D, v::String)  = set_scale!(a.yaxis, v)

yscale!(v) = yscale!(gca(), v)
yscale(v)  = y2scale!(gca(), v)

y2scale!(a::Axes2D, v::String) = set_scale!(a.yaxis, v)
y2scale(a::Axes2D, v::String) = set_scale!(a.yaxis, v)

y2scale!(v) = y2scale!(gca(), v)
y2scale(v)  = y2scale!(gca(), v)
