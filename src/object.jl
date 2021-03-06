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
    return PreviewFigure(gcf())
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
    return PreviewFigure(gcf())
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
    return PreviewFigure(gcf())
end


"""
    colorbar(zmin, zmax, cmap; o...)

Add a colorbar on a side of the axes corresponding to the span `[zmin,zmax]` with a given colormap
`cmap` (vector of colors).
"""
function colorbar(zmin::Real, zmax::Real, cmap::Vector{<:Color}; axes=nothing, o...)
    axes = check_axes(axes)
    # check if there is an existing colorbar, if so remove it
    mask = isa.(axes.objects, Colorbar)
    b = Colorbar(fl(zmin), fl(zmax), cmap)
    # axes adjustment
    if b.position ∈ ["left","right"] # horizontal
        axes.scale = "0.8 auto"
    else
        axes.scale = "auto 0.8"
    end
    set_properties!(b; defer_preview=true, o...)
    if any(mask)
        axes.objects[findfirst(mask)] = b
    else
        push!(axes.objects, b)
    end
    return PreviewFigure(gcf())
end

"""
    colorbar(h; o...)

Adds a colorbar to a drawing handle generated by a heatmap.

### Example

```julia
h = heatmap(randn(20, 20))
colorbar(h)
```
"""
colorbar(dh::DrawingHandle{Heatmap}; o...) =
    colorbar(dh.drawing.zmin, dh.drawing.zmax, dh.drawing.cmap; o...)
