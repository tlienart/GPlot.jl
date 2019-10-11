####
#### this is for extra drawings that are not meant to be overlaid with anything
#### else such as boxplot, heatmap, polarplot, pieplot
####

"""
    boxplot(...)

Erase previous drawings and add a boxplot. Missing values are allowed but not Infinities or Nans.
"""
function boxplot(ys...; axes=nothing, o...)
    axes = check_axes(axes)
    reset!(axes; parent=axes.parent) # always on fresh axes

    isempty(first(ys)) && throw(ArgumentError("Cannot display empty vectors."))

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
            iqr = q75 - q25
            mu  = mean(yk)

            wrlength = bp.boxstyles[k].wrlength
            wlow  = q25 - wrlength * iqr
            whigh = q75 + wrlength * iqr
            if isinf(wrlength)
                wlow, whigh = q00, q100 # min/max values
            end

            stats[k, :] = [wlow, q25, q50, q75, whigh, mu]

            # outliers
            outliers[k] = filter(e->(e<wlow || whigh<e), yk)

            # keep track of extremes to adjust axis limits later on
            q00  < overallmin && (overallmin = q00)
            q100 > overallmax && (overallmax = q100)
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
        @show overallmin - 0.5abs(overallmin)
        @show overallmax + 0.5abs(overallmax)
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
    return DrawingHandle(bp)
end

####
#### HEATMAP
####


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
    isempty(axes.drawings) && throw(ArgumentError("No heatmap found."))
    # it must necessarily be the first object since heatmap resets the axes
    axes.drawings[1] isa Heatmap || throw(ArgumentError("No heatmap found."))
    nrows, ncols = size(axes.drawings[1].data)
    ax_lc = lowercase(ax)
    ax_lc ∈ ["x", "x2"] && return (collect(0:(ncols-1)) .+ 0.5) ./ ncols
    ax_lc ∈ ["y", "y2"] && return (collect((nrows-1):-1:0) .+ 0.5) ./ nrows
    throw(ArgumentError("Unrecognised ax descriptor expected "*
                                               "one of [x, x2, y, y2]"))
end

"""
    heatmap(X; opts...)

Creates a heatmap corresponding to matrix `X`. Doing this with matrices larger than 100x100
with the GLE backend can be slow. As an indication, 500x500 takes about 15-20 seconds on a standard
laptop. Time scales with the number of elements (so 100x100 takes under a second).
You can provide ticks using `xticks(heatmap_ticks("x"), ["tick1", ...]; opts...)`.
See also [`heatmap_ticks`](@ref).
Note: handles missing values but not NaN or Inf.
"""
function heatmap(data::Matrix{<:CanMiss{Real}}; axes=nothing, o...)
    # TODO:
    #  - deal with tables instead of forcing matrices?
    # ================================================

    nrows, ncols = size(data)
    min(nrows, ncols) <= 1000 || throw(ArgumentError("The matrix is too large to be displayed " *
                                                     "as a heatmap."))

    axes = check_axes(axes)
    reset!(axes; parent=axes.parent) # always on fresh axes

    zmin, zmax = extrema(skipmissing(data))

    h = Heatmap(data=Matrix{Int}(undef, 0, 0), zmin=zmin, zmax=zmax)
    h.transpose = (nrows < ncols)
    set_properties!(h; defer_preview=true, o...)
    push!(axes.drawings, h)

    ncolors = length(h.cmap)

    minv, maxv = extrema(skipmissing(data))
    incr = (maxv - minv) / ncolors

    data2 = Matrix{Int}(undef, nrows, ncols)
    if iszero(incr)
        data2 .= ceil(ncols/2)
    else
        @inbounds for i=1:nrows, j=1:ncols
            dij = data[i,j]
            if ismissing(dij)
                data2[i,j] = ncolors + 1 # offset doesn't matter, anything ≥ 1 is fine
            else
                data2[i,j] = ceil(Integer, (dij - minv) / incr)
            end
        end
    end
    # NOTE: there may be a few 0 (min values), will be treated as 1 see add_sub_heatmap!

    # store the color assignments
    h.data = data2

    # set axis
    xlim(0,1); ylim(0,1)

    # add labels if provided to the heatmap object
    xplaces = heatmap_ticks("x")
    yplaces = heatmap_ticks("y")

    # used for sparse labelling in case ncols > 20
    stepx    = (ncols<=50)*10 + (50<ncols<=200)*50 + (200<ncols)*100
    lastx    = ncols - mod(ncols, stepx) + 1
    maskx    = collect(1:stepx:lastx) .- 1
    maskx[1] = 1
    stepy    = (nrows<=50)*10 + (50<nrows<=200)*50 + (200<nrows)*100
    lasty    = nrows - mod(nrows, stepy) + 1
    masky    = collect(1:stepy:lasty) .- 1
    masky[1] = 1

    if ncols <= 20
        xticks(xplaces, ["$i" for i ∈ 1:ncols]; axes=axes, fontsize=12)
    else
        xticks(xplaces[maskx], ["$i" for i ∈ maskx]; axes=axes, fontsize=12)
    end
    if nrows <= 20
        yticks(yplaces, ["$i" for i ∈ 1:nrows]; axes=axes, fontsize=12)
    else
        yticks(yplaces[masky], ["$i" for i ∈ masky]; axes=axes, fontsize=12)
    end
    x2ticks("off")
    y2ticks("off")
    return DrawingHandle(h)
end
