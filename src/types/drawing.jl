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
    Drawing

Overarching type for objects displayable on `Axes3D`.
"""
abstract type Drawing3D <: Drawing end


"""
    DrawingHandle{D<:Drawing}

Container object for a drawing returned by any plotting function.
"""
struct DrawingHandle{D<:Drawing}
    drawing::D
end


"""
    Scatter2D <: Drawing2D

2D Line plot(s) or scatter plot(s). See also [`plot!`](@ref), [`line!`](@ref) and
[`scatter!`](@ref).
"""
mutable struct Scatter2D{T} <: Drawing2D
    data        ::T                   # data container (zip; T = trick to avoid failure on 1.0)
    hasmissing  ::Bool                # whether there are missing|inf|nan data
    nobj        ::Int                 # number of objects
    linestyles  ::Vector{LineStyle}   # line style (color, width, ...)
    markerstyles::Vector{MarkerStyle} # marker style (color, size, ...)
    labels      ::Vector{String}      # plot labels (to go in the legend)
end

"""
    $SIGNATURES

Internal constructor for Scatter2D object adding linestyles, markerstyles and labels.
"""
Scatter2D(d, m, n) = Scatter2D(d, m, n, nvec(n, LineStyle), nvec(n, MarkerStyle), String[])


"""
    Fill2D <: Drawing2D

Fill-plot between two 2D curves. Missing values are not allowed. See [`fill_between!`](@ref).
"""
@with_kw mutable struct Fill2D{T} <: Drawing2D
    data     ::T  # data iterator
    #
    xmin     ::Option{Float64} = ∅           # left most anchor
    xmax     ::Option{Float64} = ∅           # right most anchor
    fillstyle::FillStyle       = FillStyle() # describes the area between the curves
    label    ::String          = ""
end


"""
    Hist2D <: Drawing2D

Histogram.
"""
@with_kw mutable struct Hist2D{T} <: Drawing2D
    data      ::T     # data container
    hasmissing::Bool  # whether has missing|inf|nan data
    nobs      ::Int   # number of non-missing entries
    range     ::T2F   # (minvalue, maxvalue)
    #
    barstyle::BarStyle    = BarStyle() #
    horiz   ::Bool        = false      # horizontal histogram?
    bins    ::Option{Int} = ∅          # number of bins
    scaling ::String      = "none"     # scaling (pdf, count=none, probability)
    label   ::String      = ""
end


"""
    Bar2D <: Drawing2D

Bar plot(s).
"""
@with_kw mutable struct Bar2D{T} <: Drawing2D
    data      ::T               # data container
    hasmissing::Bool            # whether has missing|inf|nan
    nobj      ::Int
    barstyles ::Vector{BarStyle}
    #
    stacked::Bool            = false
    horiz  ::Bool            = false
    bwidth ::Option{Float64} = ∅ # general bar width
    #
    labels ::Vector{String}  = String[]
end

"""
    Bar2D(data, hasmissing, nobj)

Internal constructor for Bar2D object adding barstyles.
"""
Bar2D(d, m, n) = Bar2D(data=d, hasmissing=m, nobj=n, barstyles=nvec(n, BarStyle))
