"""
    cla()

Clears the current axes, removing all drawings and resetting all options.
"""
cla() = (reset!(gca()); PreviewFigure(gcf()))

"""
    clo()

Clears all objects (annotations, arrows, ...) from the current axes, leaves everything else.
"""
clo() = (gca().objects = Vector{Object2D}(); PreviewFigure(gcf()))


####
#### axes
####
function axes(short::String=""; ax=nothing)
    ax = check_axes(ax)
    if !isempty(short)
        s_lc = lowercase(short)
        if s_lc == "math"
            ax.math = true
        elseif s_lc == "nomath"
            ax.math = false
        elseif s_lc == "equal"
            throw(NotImplementedError("axis(equal)"))
            #= would need to
            1. get the size from gca() to get the aspect ratio
            2. modify the xlim/ylim so that they match that ratio
            the difficulty is to get xlim/ylim when they're not set
            explicitly. would need to figure out a way
            to declare local variables
            Maybe just xaxis min xgmin*... max xgmax*...
            =#
        else
            throw(OptionValueError("Unrecognised shorthand toggle for axes.", short))
        end
    end
    return PreviewFigure(gcf())
end

####
#### [x|y|...]axis(...)
####

for axs ∈ ("x", "y", "x2", "y2")
    f  = Symbol(axs * "axis")    # :xaxis  ...
    ex = quote
        function $f(short::String=""; axes=nothing, opts...)
            axes = check_axes(axes)
            if isempty(short)
                set_properties!(axes.$f; opts...)
            else
                # try to interpret the string as a shorthand and apply on gca
                s_lc = lowercase(short)
                if s_lc == "off"
                    set_properties!(gca().$f; off=true, opts...)
                elseif s_lc == "on"
                    set_properties!(gca().$f; off=false, opts...)
                elseif s_lc == "log"
                    set_properties!(gca().$f; log=true, opts...)
                elseif s_lc ∈ ["lin", "linear"]
                    set_properties!(gca().$f; log=false, opts...)
                else
                    throw(OptionValueError("Unrecognised shorthand toggle for axis.", short))
                end
            end
            return PreviewFigure(gcf())
        end
    end
    eval(ex)
end

"""
    math(s;...)

Toggle the (current) axes to math mode (where the axes go through (0,0)).
to reverse this (`b=false`) It is recommended to also adjust the axis limits via [`xlim`](@ref)
and [`ylim`](@ref) to make sure that the origin is somewhere in the drawn area (otherwise the
results will be rather ugly).

### Examples

```julia
math()
math("on")
math("off")
```
"""
function math(short::String=""; axes=nothing)
    axes = check_axes(axes)
    s_lc = lowercase(short)
    if isempty(short) || s_lc == "on"
         axes.math = true
    elseif s_lc == "off"
        axes.math = false
    else
        throw(OptionValueError("Unrecognised shorthand toggle for math.", short))
    end
    return PreviewFigure(gcf())
end

"""
    grid()

Set grid mode on. By default the grid will be associated with both `xticks` and `yticks` but you
can also specify one axis to only have horizontal or vertical lines by passing `axis=["x"]`.
Options can be passed to specify the color of the grid, the style of the lines or their width.

### Examples

```julia
grid(linestyle="-.")
grid(axis=["y"], linestyle="--", color="lightgray")
```
"""
function grid(short::String=""; axes=nothing, axis::Vector{String}=["x", "y"],
               opts...)
    axes = check_axes(axes)
    if !isempty(short)
        s_lc = lowercase(short)
        if s_lc == "off"
            axes.xaxis.ticks.grid = false
            axes.yaxis.ticks.grid = false
            return PreviewFigure(gcf())
        elseif s_lc == "on"
            axes.xaxis.ticks.grid = true
            axes.yaxis.ticks.grid = true
            return PreviewFigure(gcf())
        else
            throw(OptionValueError("Unrecognised shorthand toggle for grid.", short))
        end
    end
    for ax ∈ axis
        ax_lc = lowercase(ax)
        ax_lc ∈ ("x","x2","y","y2") || throw(OptionValueError("Unrecognized axis symbol(s).", axis))
        # all options affect the ticks (in particular: color and width)
        axsym = Symbol(ax_lc * "axis")
        ticks = eval(:($axes.$axsym.ticks))
        ticks.grid = true
        for optname ∈ opts.itr
            if optname ∈ (:col, :color)
                set_color!(ticks, col(opts[optname], optname))
            elseif optname ∈ (:ls, :lstyle, :linestyle)
                set_lstyle!(ticks, opts[optname])
            elseif optname ∈ (:lw, :lwidth, :linewidth)
                set_lwidth!(ticks, posfl(opts[optname], optname))
            else
                throw(UnknownOptionError(optname, ax))
            end
        end
    end
    return PreviewFigure(gcf())
end

####
#### [x|y]lim, [x|y]lim! (synonyms though with ! is preferred)
####

function _lim(axis_sym::Symbol, min::Option{Float64}, max::Option{Float64}; axes=nothing)
    axes = check_axes(axes)
    if min !== nothing && max !== nothing
        min < max || throw(ArgumentError("min must be smaller than max (got ($min, $max))"))
    end
    axis = getfield(axes, axis_sym)
    setfield!(axis, :min, min)
    setfield!(axis, :max, max)
    return PreviewFigure(gcf())
end

# Generate *lim each axis
for axs ∈ ("x", "y", "x2", "y2")
    f  = Symbol(axs * "lim")
    ex = quote
        $f(min, max; o...) = _lim(Symbol($axs * "axis"), fl(min), fl(max); o...)
        $f(; min=∅, max=∅) = _lim(Symbol($axs * "axis"), fl(min), fl(max))
    end
    eval(ex)
end

####
#### [x|y]scale
####

function _scale(axis_sym::Symbol, v::String; axes=nothing)
    axes = check_axes(axes)
    axis = getfield(axes, axis_sym)
    axis.log = get(AXSCALE, v) do
        throw(OptionValueError("axis scale", v))
    end
    return PreviewFigure(gcf())
end

# Generate *scale for each axis
for axs ∈ ("x", "y", "x2", "y2")
    f  = Symbol(axs * "scale")
    eval(:($f(v::String; o...) = _scale(Symbol($axs * "axis"), v, o...)))
end
