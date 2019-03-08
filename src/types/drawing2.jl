"""
    Boxplot <: Drawing2D

Boxplot(s).
"""
@with_kw mutable struct Boxplot <: Drawing2D
    stats::Matrix{Float64}  # quantile etc
    nobj ::Int
    #
    boxstyles::Vector{BoxplotStyle}
    #
    horiz::Bool = false # vertical boxplots by default
end
Boxplot(d, n) = Boxplot(stats=d, nobj=n, boxstyles=nvec(n, BoxplotStyle))


"""
    Heatmap <: Drawing2D

Heatmap of a matrix.
"""
@with_kw mutable struct Heatmap <: Drawing2D
    data::Matrix{Int}
    zmin::Float64
    zmax::Float64
    #
    cmap::Vector{Color} = colormap("RdBu", 10)
    cmiss::Color = c"white" # box filling for missing values
    # transpose
    # whether to write the matrix as a transpose
    # this is useful because GLE can deal only with 1000-cols
    # files at most (at least with the way we do the heatmap now)
    transpose::Bool = false
end
