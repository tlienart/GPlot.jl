####
#### Data assembling
####

function plotdata(x)
    x isa AVM{<:CanMiss{<:Real}} || throw(ArgumentError("x has un-handled type $(typeof(x))"))
    hasmissing = Missing <: eltype(x)
    hasmissing = hasmissing || any(isinf, x)
    hasmissing = hasmissing || any(isnan, x)
    return (data=zip(1:size(x, 1), eachcol(x)...),
            hasmissing=hasmissing,
            nobj=size(x, 2))
end
function plotdata(x, ys...)
    x isa AV{<:CanMiss{<:Real}} || throw(ArgumentError("x has un-handled type $(typeof(x))"))
    nobj = 0
    hasmissing = Missing <: eltype(x)
    hasmissing = hasmissing || any(isinf, x)
    hasmissing = hasmissing || any(isnan, x)
    for y ∈ ys
        y isa AVM{<:CanMiss{<:Real}} || throw(ArgumentError("y has un-handled type $(typeof(y))"))
        size(y, 1) == length(x) || throw(DimensionMismatch("y data must match x"))
        nobj += size(y, 2)
        hasmissing = hasmissing || Missing <: eltype(y)
        hasmissing = hasmissing || any(isinf, y)
        hasmissing = hasmissing || any(isnan, y)
    end
    return (data=zip(x, (view(y, :, j) for y ∈ ys for j ∈ axes(y, 2))...),
            hasmissing=hasmissing, nobj=nobj)
end

function filldata(x::AVR, y1::Union{Real,AVR}, y2::Union{Real,AVR})
    y1 isa AV || (y1 = fill(y1, length(x)))
    y2 isa AV || (y2 = fill(y2, length(x)))
    length(x) == length(y1) == length(y2) ||throw(DimensionMismatch("vectors must have " *
                                                                    "matching lengths"))
    return (data=zip(x, y1, y2))
end

function histdata(x::AV{<:CanMiss{<:Real}})
    sx = skipmissing(x)
    return (data=zip(x),
            hasmissing=(Missing <: eltype(x)),
            nobs=sum(e->1, sx),
            range=fl((minimum(sx), maximum(sx))))
end


#################################################################################
#################################################################################

####
#### plot, plot!
####

"""
    plot!(...)

Add a plot. Keyword arguments can be passed to specify the linestyle(s), label(s) and
markerstyle(s).

## Example

```julia
x = range(-2, 2, length=100)
y = @. exp(-abs(x)+sin(x))
plot(x, y, color="blue", lstyle="--", marker="o", lwidth=0.05, label="First plot")
```
"""
function plot!(x, ys...; axes=nothing, overwrite=false, o...)::Option{PreviewFigure}
    axes = check_axes(axes)
    overwrite && erase!(axes)
    pd = plotdata(x, ys...)
    scatter = Scatter2D(pd.data, pd.hasmissing, pd.nobj)
    set_properties!(scatter; defer_preview=true, o...)
    push!(axes.drawings, scatter)
    return _preview()
end

function plot!(f::Function, from, to; length=100, o...)
    x = range(from, to, length=length)
    plot!(x, f.(x); o...)
end

"""
    plot(...)

Erase previous drawings and add a plot. See also [`plot!`](@ref).
"""
plot(a...; o...) = plot!(a...; overwrite=true, o...)

"""
    scatter!(...)

Add a scatter plot (no line joins the points). See also [`plot!`](@ref).
"""
scatter!(a...; o...) = plot!(a...; ls="none", marker="o", o...)

"""
    scatter(...)

Erase previous drawings and add a scatter plot (no line joins the points). See also [`plot`](@ref).
"""
scatter(a...; o...)  = plot!(a...; ls="none", marker="o", overwrite=true, o...)

####
#### line, line!
####

"""
    line!(from, to; options)

Add a line from `from` (in `[x, y]` format) to `to` (same format). For instance
```julia
line!([0, 0], [1, 1]; ls="--")
```
"""
line!(a::AVR, b::AVR; o...) = plot!([a[1],b[1]], [a[2],b[2]]; o...)

"""
    line(from, to; options)

Erase previous drawings and add a line. See also [`line!`](@ref).
"""
line(a...; o...)  = line!(a...; overwrite=true, o...)

####
#### fill_between!, fill_between
####

"""
    fill_between!(...)

Add a fill plot between two lines. The arguments must not have missings but `y1` and/or `y2` can
be specified as single numbers (= horizontal line).
"""
function fill_between!(x, y1, y2; axes=nothing, overwrite=false, o...)::Option{PreviewFigure}
    axes = check_axes(axes)
    overwrite && erase!(axes)
    fill = Fill2D(data=filldata(x, y1, y2))
    set_properties!(fill; defer_preview=true, o...)
    push!(axes.drawings, fill)
    return _preview()
end

"""
    fill_between(...)

Erase previous drawings and add a fill plot. See also [`fill_between!`](@ref).
"""
fill_between(a...; o...) = fill_between!(a...; overwrite=true, o...)

####
#### hist, hist!
####

"""
    hist!(...)

Add a histogram of `x` on the current axes.
"""
function hist!(x; axes=nothing, overwrite=false, o...)::Option{PreviewFigure}
    axes = check_axes(axes)
    overwrite && erase!(axes)
    hd = histdata(x)
    hist = Hist2D(data=hd.data, hasmissing=hd.hasmissing, nobs=hd.nobs, range=hd.range)
    set_properties!(hist; defer_preview=true, o...)
    push!(axes.drawings, hist)
    return _preview()
end

"""
    hist(...)

Erase previous drawings and add a histogram. See also [`hist!`](@ref).
"""
hist(a...; o...)  = hist!(a...; overwrite=true, o...)

####
#### bar!, bar
####

"""
    bar!(...)

Add a bar plot.
"""
function bar!(x, ys...; axes=nothing, overwrite=false, o...)::Option{PreviewFigure}
    axes = check_axes(axes)
    overwrite && erase!(axes)
    bd = plotdata(x, ys...)
    bar = Bar2D(bd.data, bd.hasmissing, bd.nobj)
    set_properties!(bar; defer_preview=true, o...)
    push!(axes.drawings, bar)
    return _preview()
end

"""
    bar(...)

Erase previous drawings and add a bar plot. See also [`bar!`](@ref).
"""
bar(a...; o...) =  bar!(a...; overwrite=true, o...)
