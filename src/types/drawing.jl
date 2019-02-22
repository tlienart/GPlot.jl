"""
    Drawing

Overarching type for objects displayable on `Axes`.
"""
abstract type Drawing end


"""
    Drawing

Overarching type for objects displayable on `Axes2D`.
"""
abstract type Drawing2D <: Drawing end


"""
    Scatter2D <: Drawing2D

2D Line plot(s) or scatter plot(s). See also [`plot!`](@ref), [`line!`](@ref) and
[`scatter!`](@ref).
"""
mutable struct Scatter2D <: Drawing2D
    z           ::Base.Iterators.Zip  # an iterator over the lines of e.g. (x, y)
    hasmissing  ::Bool                # whether there are missing data
    nobj        ::Int                 # number of objects
    linestyles  ::Vector{LineStyle}   # line style (color, width, ...)
    markerstyles::Vector{MarkerStyle} # marker style (color, size, ...)
    labels      ::Vector{String}      # plot labels (to go in the legend)
end
function Scatter2D(z::Base.Iterators.Zip, hasmissing::Bool, nobj::Int)
    Scatter2D(z, hasmissing, nobj,
              [LineStyle() for i in 1:nobj], [MarkerStyle() for i in 1:nobj], String[])
end


"""
    Fill2D <: Drawing2D

Fill-plot between two 2D curves. Missing values are not allowed. See [`fill_between!`](@ref).
"""
mutable struct Fill2D <: Drawing2D
    z        ::Base.Iterators.Zip
    xmin     ::Option{Float64}
    xmax     ::Option{Float64}
    fillstyle::FillStyle
end
Fill2D(z::Base.Iterators.Zip) = Fill2D(z, nothing, nothing, FillStyle())


"""
    Hist2D <: Drawing2D

Histogram.
"""
mutable struct Hist2D <: Drawing2D
    z         ::Base.Iterators.Zip # wrapper around the data
    hasmissing::Bool               # whether has missings
    nobs      ::Int                # number of non-missing entries
    range     ::T2F
    barstyle  ::BarStyle           # barstyle
    horiz     ::Bool               # horizontal histogram?
    bins      ::Option{Int}        # number of bins
    scaling   ::Option{String}     # scaling (pdf, ...)
end
function Hist2D(z::Base.Iterators.Zip, hasmissing::Bool, nobs::Int, range::T2F)
    Hist2D(z, hasmissing, nobs, range, BarStyle(), false, nothing, nothing)
end

"""
    Bar2D <: Drawing2D

Bar plot(s).
"""
mutable struct Bar2D <: Drawing2D
    z         ::Base.Iterators.Zip
    hasmissing::Bool
    nobj      ::Int
    barstyles ::Vector{BarStyle}
    stacked   ::Bool
    horiz     ::Bool
    width     ::Option{Float64}
end
function Bar2D(z::Base.Iterators.Zip, hasmissing::Bool, nobj::Int)
    Bar2D(z, hasmissing, nobj, [BarStyle() for i ∈ 1:nobj],
          false, false, nothing)
end
