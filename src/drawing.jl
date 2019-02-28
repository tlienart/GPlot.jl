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
# NOTE: these typechecks within the function body is to avoid clashes/ambiguity with plotdata(x)
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
function plot!(x, ys...; axes=nothing, overwrite=false, o...)
    axes = check_axes(axes)
    if overwrite
        # are current axes empty? if so don't do anything as the user may have pre-specified
        # things like xlim etc and want the plot to appear with those
        # if it's not empty, reset the axes (will destroy xlim settings etc as it should)
        all(isempty, (axes.drawings, axes.objects)) || reset!(axes)
    end
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
    overwrite && all(isempty, (axes.drawings, axes.objects)) || reset!(axes)
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
    overwrite && all(isempty, (axes.drawings, axes.objects)) || reset!(axes)
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
    overwrite && all(isempty, (axes.drawings, axes.objects)) || reset!(axes)
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

"""
    boxplot(...)

Erase previous drawings and add a boxplot. Missing values are allowed but not Infinities or Nans.
"""
function boxplot(ys...; axes=nothing, o...)
    axes = check_axes(axes)
    reset!(axes) # always on fresh axes

    # setting an empty struct first so that we can exploit the options
    # the actual data will be provided after analysis
    nobj = sum(size(y, 2) for y ∈ ys)
    bp = Boxplot(Matrix{Float64}(undef,0,0), nobj)
    set_properties!(bp; defer_preview=true, o...)

    # analyse data
    stats = Matrix{Float64}(undef, nobj, 6) # 1:wlow, 2:q25, 3:q50, 4:q75, 5:whigh, 6:mean
    outliers = Vector{Vector{Float64}}(undef, nobj)

    boxcounter = 1
    overallmax = -Inf
    overallmin = Inf

    for y ∈ ys
        for k ∈ Base.axes(y, 2)
            yk = collect(skipmissing(view(y, :, k)))
            if any(isnan, yk) || any(isinf, yk)
                throw(ArgumentError("Inf or NaN values not allowed in boxplot."))
            end

            q00, q25, q50, q75, q100 = quantile(yk, [.0, .25, .5, .75, 1.0])
            iqr   = q75 - q25
            mean  = sum(yk)/length(yk)

            wrlength = bp.boxstyles[k].wrlength
            wlow  = q25 - wrlength * iqr
            whigh = q75 + wrlength * iqr
            if isinf(wrlength)
                wlow, whigh = q00, q100 # min/max values
            end

            stats[k, :] = [wlow, q25, q50, q75, whigh, mean]

            # outliers
            outliers[k] = collect(filter(e->(e<wlow || whigh<e), yk))

            # keep track of extremes to adjust axis limits later on
            overallmin > q00  && (overallmin = q00)
            overallmax < q100 && (overallmax = q100)
            boxcounter += 1
        end
    end
    #
    bp.stats = stats
    push!(axes.drawings, bp)

    # adjust axis limits, show outliers if relevant
    if bp.horiz # horizontal boxplot
        ylim(0, nobj+1)
        yticks(1:nobj)
        xlim(overallmin - 0.5abs(overallmin), overallmax + 0.5abs(overallmax))
        for k ∈ 1:nobj
            bp.boxstyles[k].oshow || continue
            nok = length(outliers[k])
            s = bp.boxstyles[k].omstyle # style of outliers
            if nok > 0
                scatter!(outliers[k], fill(k, nok); marker=s.marker, msize=s.msize, mcol=s.color)
            end
        end
    else # vertical boxplot
        xlim(0, nobj+1)
        xticks(1:nobj)
        ylim(overallmin - 0.5abs(overallmin), overallmax + 0.5abs(overallmax))
        for k ∈ 1:nobj
            bp.boxstyles[k].oshow || continue
            nok = length(outliers[k])
            s = bp.boxstyles[k].omstyle # style of outliers
            if nok > 0
                scatter!(fill(k, nok), outliers[k]; marker=s.marker, msize=s.msize, mcol=s.color)
            end
        end
    end
    return preview() # not a handle, this does not have a legend
end
