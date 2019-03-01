# NOTE objects don't have the overwrite property. so with or witout ! they don't
# overwrite the axes they get placed on.

"""
    text(text, anchor)

### Example

```julia
text(t"x^{\\star}", (1, 1.5); fontsize=15)
```
"""
function text(text::String, anchor::Tuple; axes=nothing, o...)
    axes = check_axes(axes)
    t = Text2D(text=text, anchor=fl(anchor))
    set_properties!(t; defer_preview=true, o...)
    push!(axes.objects, t)
    return preview()
end

"""
    _line(...)

Internal function to draw a horizontal or vertical line from axis to axis. See [`vline`](@ref)
and [`hline`](@ref).
"""
function _line(anchor::Float64, horiz::Bool; axes=nothing, o...)
    axes = check_axes(axes)
    l = StraightLine2D(anchor=anchor, horiz=horiz)
    set_properties!(l; defer_preview=true, o...)
    push!(axes.objects, l)
    return preview()
end

"""
    vline(anchor; opts...)

Add a vertical line at a given point from the xaxis to the x2axis. Note that this does not adapt
the xaxis limits so if the point specified is outside of the current xaxis limits you won't see
anything (until you adjust the limits accordingly).

### Example

```julia
vline(0; color="red")
```
"""
vline(anchor::Real; o...) = _line(fl(anchor), false; o...)

"""
    hline(anchor; opts...)

Add a horizontal line at a given point from the yaxis to the y2axis. Note that this does not adapt
the axis limits so if the point specified is outside of the current axis limits you won't see
anything (until you adjust the limits accordingly).

### Example

```julia
hline(0; color="red")
```
"""
hline(anchor::Real; o...) = _line(fl(anchor), true; o...)

"""
    line(from, to; options)

Add a line from `from` (in `[x, y]` format) to `to` (same format).

### Example

```julia
line([0, 0], [1, 1]; ls="--")
line((0, 0), (1, 1)) # also valid
```
"""
line(a::Union{AVR,T2R}, b::Union{AVR,T2R}; o...) = plot!([a[1],b[1]], [a[2],b[2]]; o...)


"""
    box(anchor; opts...)

Add a box at position `anchor`.
### Example

```julia
text(t"x^{\\star}", (1, 1.5); fontsize=15)
```
"""
function box(size::Tuple, anchor::Tuple; axes=nothing, o...)
    axes = check_axes(axes)
    b = Box2D(anchor=fl(anchor), size=fl(size))
    set_properties!(b; defer_preview=true, o...)
    push!(axes.objects, b)
    return preview()
end

"""
    heatmap_ticks(ax)

Returns ticks position centered appropriately for a heatmap.

### Example

```julia
heatmap(randn(2, 2))
xticks(heatmap_ticks("x"), ["var1", "var2"]; angle=45)
```
"""
function heatmap_ticks(ax::String; axes=gca())
    isempty(axes.objects) && throw(ArgumentError("No heatmap found."))
    # it must necessarily be the first object since heatmap resets the axes
    axes.objects[1] isa Heatmap || throw(ArgumentError("No heatmap found."))
    nrows, ncols = size(axes.objects[1].data)
    ax_lc = lowercase(ax)
    ax_lc ∈ ["x", "x2"] && return (collect(0:(ncols-1)) .+ 0.5) ./ ncols
    ax_lc ∈ ["y", "y2"] && return (collect(0:(nrows-1)) .+ 0.5) ./ nrows
    throw(ArgumentError("Unrecognised ax descriptor expected "*
                                               "one of [x, x2, y, y2]"))
end

"""
    heatmap(X; opts...)

Creates a heatmap corresponding to matrix `X`. Doing this with matrices larger than 100x100
with the GLE backend can be slow. As an indication, 500x500 takes about 20 seconds on a standard
laptop. Time scales with the number of elements (so 100x100 takes under a second).
"""
function heatmap(data::Matrix{Float64}; axes=nothing, o...)
    # TODO:
    #  - missings should be displayed as white?
    #  - deal with tables instead of forcing matrices?
    # ==================================
    axes = check_axes(axes)
    reset!(axes) # always on fresh axes

    h = Heatmap(data=data)
    set_properties!(h; defer_preview=true, o...)
    push!(axes.objects, h)

    # set axis
    xlim(0,1)
    ylim(0,1)
    nrows, ncols = size(data)

    # add labels if provided to the heatmap object
    xplaces = (collect(0:(ncols-1)) .+ 0.5) ./ ncols
    if isempty(h.xnames)
        xticks(xplaces, [t"{\it x}_{##i}" for i ∈ 1:ncols]; axes=axes, fontsize=12)
    else
        xticks(xplaces, h.xnames; length=0, axes=axes)
    end
    if isempty(h.x2names)
        x2ticks("off"; axes=axes)
    else
        x2ticks(xplaces, h.x2names; length=0, axes=axes)
    end
    yplaces = (collect(0:(nrows-1)) .+ 0.5) ./ nrows
    if isempty(h.ynames)
        yticks(yplaces, [t"{\it y}_{##i}" for i ∈ 1:nrows]; axes=axes, fontsize=12)
    else
        yticks(yplaces, h.ynames; length=0, axes=axes)
    end
    if isempty(h.y2names)
        y2ticks("off"; axes=axes)
    else
        y2ticks(yplaces, h.y2names; length=0, axes=axes)
    end

    return preview()
end
