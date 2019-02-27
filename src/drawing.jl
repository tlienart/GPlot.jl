####
#### Data assembling
####

function plotdata(x::AVM{<:CanMiss{<:Real}})
    hasmissing = Missing <: eltype(x)
    hasmissing = hasmissing || any(isinf, x)
    hasmissing = hasmissing || any(isnan, x)
    return (data=zip(1:size(x, 1), eachcol(x)...),
            hasmissing=hasmissing,
            nobj=size(x, 2))
end
function plotdata(x::AV{<:CanMiss{<:Real}}, ys...)
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
function plot!(x, ys...; axes=nothing, overwrite=false, o...)
    axes = check_axes(axes)
    overwrite && erase(axes)
    pd = plotdata(x, ys...)
    scatter = Scatter2D(pd.data, pd.hasmissing, pd.nobj)
    set_properties!(scatter; defer_preview=true, o...)
    push!(axes.drawings, scatter)
    return DrawingHandle(scatter)
end

function plot!(f::Function, from, to; length=100, o...)
    x = range(from, stop=to, length=length)
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
#### fill_between!, fill_between
####

"""
    fill_between!(...)

Add a fill plot between two lines. The arguments must not have missings but `y1` and/or `y2` can
be specified as single numbers (= horizontal line).
"""
function fill_between!(x, y1, y2; axes=nothing, overwrite=false, o...)
    axes = check_axes(axes)
    overwrite && erase(axes)
    fill = Fill2D(data=filldata(x, y1, y2))
    set_properties!(fill; defer_preview=true, o...)
    push!(axes.drawings, fill)
    return DrawingHandle(fill)
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
function hist!(x; axes=nothing, overwrite=false, o...)
    axes = check_axes(axes)
    overwrite && erase(axes)
    hd = histdata(x)
    hist = Hist2D(data=hd.data, hasmissing=hd.hasmissing, nobs=hd.nobs, range=hd.range)
    set_properties!(hist; defer_preview=true, o...)
    push!(axes.drawings, hist)
    return DrawingHandle(hist)
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
function bar!(x, ys...; axes=nothing, overwrite=false, o...)
    axes = check_axes(axes)
    overwrite && erase(axes)
    bd = plotdata(x, ys...)
    bar = Bar2D(bd.data, bd.hasmissing, bd.nobj)
    set_properties!(bar; defer_preview=true, o...)
    push!(axes.drawings, bar)
    return DrawingHandle(bar)
end

"""
    bar(...)

Erase previous drawings and add a bar plot. See also [`bar!`](@ref).
"""
bar(a...; o...) =  bar!(a...; overwrite=true, o...)


####
#### this is for extra drawings that are not meant to be overlaid with anything
#### else such as boxplot, polarplot, pieplot
####

function boxplot(ys...; axes=nothing, o...)
    axes = check_axes(axes)
    nobj = sum(size(y, 2) for y ∈ ys)
    bp = Boxplot(bd.data, nobj)
    set_properties!(bp; defer_preview=true, o...)
    push!(axes.drawings, bp)
    return preview() # not a handle, this does not have a legend
end
