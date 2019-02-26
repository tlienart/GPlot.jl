"""
    erase!(axes)

Cleans up `axes` for a new drawing, keeps all other properties the same (ticks, ...).
"""
function erase!(a::Axes2D)
    a.drawings = Vector{Drawing2D}()
    a.objects  = Vector{Object2D}()
    a.legend   = ∅
    GP_ENV["CURAXES"] = a
    return preview()
end

"""
    cla!()

Clears the current axes, removing all drawings and resetting all options.
"""
cla!() = (reset!(gca()); preview())

"""
    cla()

See [`cla!`](@ref).
"""
cla = cla!

"""
    clo!()

Clears all objects (annotations, arrows, ...) from the current axes, leaves everything else.
"""
clo!() = (gca().objects = Vector{Object2D}(); preview())

"""
    clo()

See [`clo!`](@ref).
"""
clo = clo!

####
#### [x|y|...]axis(...)
####

for axs ∈ ("x", "y", "x2", "y2")
    f! = Symbol(axs * "axis!")   # :xaxis! ...
    f  = Symbol(axs * "axis")    # :xaxis  ...
    ex = quote
        function $f!(short::String=""; axes=nothing, opts...)
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
            return preview()
        end
        $f = $f! # synonyms
    end
    eval(ex)
end

"""
    math!(;...)

Set the (current) axes to math mode (where the axes go through (0,0)). It is recommended to also
adjust the axis limits via [`xlim!`](@ref) and [`ylim!`](@ref) to make sure that the origin is
somewhere in the drawn area (otherwise the results will be rather ugly).
"""
math!(; axes=nothing) = (axes = check_axes(axes); axes.math = true; preview())

"""
    math()

See [`math!`](@ref).
"""
math = math!

"""
    grid!()

Set grid mode on. By default the grid will be associated with both `xticks` and `yticks` but you
can also specify one axis to only have horizontal or vertical lines by passing `axis=["x"]`.
Options can be passed to specify the color of the grid, the style of the lines or their width.

### Examples

```julia
grid!(linestyle="-.")
grid!(axis=["y"], linestyle="--", color="lightgray")
```
"""
function grid!(short::String=""; axes=nothing, axis::Vector{String}=["x", "y"],
               opts...)
    axes = check_axes(axes)
    if !isempty(short)
        s_lc = lowercase(short)
        if s_lc == "off"
            axes.xaxis.ticks.grid = false
            axes.yaxis.ticks.grid = false
            return preview()
        elseif s_lc == "on"
            axes.xaxis.ticks.grid = true
            axes.yaxis.ticks.grid = true
            return preview()
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
    return preview()
end

"""
    grid()

See [`grid!`](@ref).
"""
grid = grid!

####
#### [x|y]lim, [x|y]lim! (synonyms though with ! is preferred)
####

function _lim!(axis_sym::Symbol, min::Option{Float64}, max::Option{Float64};
               axes=nothing)
    axes = check_axes(axes)
    if min !== nothing && max !== nothing
        min < max || throw(ArgumentError("min must be smaller than max (got ($min, $max))"))
    end
    axis = getfield(axes, axis_sym)
    setfield!(axis, :min, min)
    setfield!(axis, :max, max)
    return preview()
end

# Generate xlim!, xlim, and associated for each axis
for axs ∈ ("x", "y", "x2", "y2")
    f! = Symbol(axs * "lim!")
    f  = Symbol(axs * "lim")
    ex = quote
        $f!(min, max; o...) = _lim!(Symbol($axs * "axis"), fl(min), fl(max); o...)
        $f!(; min=nothing, max=nothing) = _lim!(Symbol($axs * "axis"), fl(min), fl(max))
        # synonyms
        $f = $f!
    end
    eval(ex)
end

####
#### [x|y]scale, [x|y]scale! (synonyms though with ! is preferred)
####

function _scale!(axis_sym::Symbol, v::String; axes=nothing)
    axes = check_axes(axes)
    axis = getfield(axes, axis_sym)
    axis.log = get(AXSCALE, v) do
        throw(OptionValueError("axis scale", v))
    end
    return preview()
end

# Generate xscale!, xscale, and associated for each axis
for axs ∈ ("x", "y", "x2", "y2")
    f! = Symbol(axs * "scale!")       # xscale!
    f  = Symbol(axs * "scale")        # xscale
    ex = quote
        $f!(v::String; o...) = _scale!(Symbol($axs * "axis"), v, o...)
        # synonyms
        $f = $f!
    end
    eval(ex)
end
