"""
    cla!()

Clears the current axes, removing all drawings and resetting all options.
"""
cla!() = reset!(gca()) # erase! removes drawings, clear! removes options
cla = cla!

####
#### [x|y|...]axis(...)
####

for axs ∈ ("x", "y", "x2", "y2")
    f! = Symbol(axs * "axis!")   # :xaxis! ...
    f  = Symbol(axs * "axis")    # :xaxis  ...
    ff = Symbol(axs[1] * "axis") # :x2axis->:xaxis (for grid)
    ex = quote
        $f!(a::Axis; opts...)   = (set_properties!(a; opts...); a)
        $f!(a::Axes; opts...)   = (set_properties!(a.$f; opts...); a)
        $f!(::Nothing; opts...) = $f!(add_axes2d!(); opts...)
        function $f!(s::String=""; opts...)
            isempty(s) && return $f!(gca(); opts...)
            # try to interpret the string as a shorthand
            s_lc = lowercase(s)
            s_lc == "off"  && return $f!(gca(); off=true, opts...)
            s_lc == "log"  && return $f!(gca(); log=true, opts...)
            throw(OptionValueError("Unrecognised shorthand toggle for axis.", s))
        end
        $f = $f! # synonym
    end
    eval(ex)
end

math!(a::Axes2D) = (a.math = true; a)
math!(::Nothing) = (add_axes2d!(); math!(gca()))
math!() = math!(gca())
math = math!

function grid!(a::Axes2D; which::Vector{String}=["x", "y"], opts...)
    for ax ∈ which
        ax_lc = lowercase(ax)
        @assert ax_lc ∈ ("x", "x2", "y", "y2") "Unrecognized ax symbol $ax."
        # all options affect the ticks (in particular: color and width)
        axsym = Symbol(ax_lc * "axis")
        ticks = eval(:($a.$axsym.ticks))
        ticks.grid = true
        for optname ∈ opts.itr
            if optname ∈ (:col, :color)
                set_tickscolor!(ticks, col(opts[optname], optname))
            elseif optname ∈ (:ls, :lstyle, :linestyle)
                set_lstyle!(ticks, opts[optname])
            elseif optname ∈ (:lw, :lwidth, :linewidth)
                set_lwidth!(ticks, posfl(opts[optname], optname))
            else
                throw(UnknownOptionError(optname, a))
            end
        end
    end
    return a
end
grid!(::Nothing; opts...) = grid!(add_axes2d!(); opts...)
grid!(; opts...) = grid!(gca(); opts...)
grid = grid!

####
#### [x|y]lim, [x|y]lim! (synonyms though with ! is preferred)
####

function _lim!(a::Axes2D, el::Symbol, min::Option{Float64}, max::Option{Float64})
    if min !== nothing && max !== nothing
        @assert min < max "min must be strictly smaller than max"
    end
    axis = getfield(a, el)
    setfield!(axis, :min, min)
    setfield!(axis, :max, max)
    return a
end
_lim!(::Nothing, el, min, max) = _lim!(add_axes2d!(), el, min, max)

# Generate xlim!, xlim, and associated for each axis
for axs ∈ ("x", "y", "x2", "y2")
    f! = Symbol(axs * "lim!")
    f  = Symbol(axs * "lim")
    ex = quote
        $f!(a, min, max)    = _lim!(a, Symbol($axs * "axis"), fl(min), fl(max))
        $f!(min, max)       = _lim!(gca(), Symbol($axs * "axis"), fl(min), fl(max))
        $f!(; min=∅, max=∅) = _lim!(gca(), Symbol($axs * "axis"), fl(min), fl(max))
        # synonyms
        $f(a, min, max)    = _lim!(a, Symbol($axs * "axis"), fl(min), fl(max))
        $f(min, max)       = _lim!(gca(), Symbol($axs * "axis"), fl(min), fl(max))
        $f(; min=∅, max=∅) = _lim!(gca(), Symbol($axs * "axis"), fl(min), fl(max))
    end
    eval(ex)
end

####
#### [x|y]scale, [x|y]scale! (synonyms though with ! is preferred)
####

function _scale!(a::Axis, v::String)
    a.log = get(AXSCALE, v) do
        throw(OptionValueError("axis scale", v))
    end
    return a
end

# Generate xscale!, xscale, and associated for each axis
for axs ∈ ("x", "y", "x2", "y2")
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
