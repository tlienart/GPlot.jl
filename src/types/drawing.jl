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

Line plot(s) or scatter plot(s). The core object is `xy` a matrix with `n` rows
and `p` columns where `n` is the number of x-axis points and `p-1` is the number
of line/scatter objects (the first column stores the x-axis points).
"""
@with_kw mutable struct Scatter2D <: Drawing2D
    xy::Matrix{Float64} # [x, y1, y2, ...]
    # --- style
    linestyle  ::Vector{LineStyle}
    markerstyle::Vector{MarkerStyle}
    # --- legend and misc
    label::Vector{String} = String[]
end

"""
    Scatter2D(xy)

Internal constructor for `Scatter2D` object initialising an empty vector of `LineStyle`
and `MarkerStyle` of the appropriate size.
"""
function Scatter2D(xy::Matrix{Float64})
    n   = size(xy, 2) - 1 # first column is x
    lss = [LineStyle()   for i ∈ 1:n]
    mss = [MarkerStyle() for i ∈ 1:n]
    Scatter2D(xy=xy, linestyle=lss, markerstyle=mss)
end

"""
    Fill2D <: Drawing2D

Fill-plots between two 2D curves. The core object is `xy1y2` a matrix with `n` rows
and `3` columns where the first column stores the `n` x-axis points, and the next two
columns store the values describing the two curves vertically delimiting the area to
draw.
"""
@with_kw mutable struct Fill2D <: Drawing2D
    xy1y2::Matrix{Float64} # [x, y1, y2], fill between y1 and y2
    xmin::Option{Float64} = ∅
    xmax::Option{Float64} = ∅
    # --- style
    fillstyle::FillStyle = FillStyle()
end

"""
    Hist2D <: Drawing2D

Histograms. The core object is `x`, a vector with `n` entries which are summarised as
a histogram.
"""
@with_kw mutable struct Hist2D <: Drawing2D
    x::Vector{Float64}
    # --- style
    barstyle::BarStyle = BarStyle()
    # ---
    horiz  ::Bool            = false
    bins   ::Option{Int}     = ∅
    scaling::Option{String}  = ∅
#    label::Option{String} = ∅ # 🚫
end

"""
    Bar2D <: Drawing2D

Bar plot(s). The core object is `xy`, a matrix with `n` rows and `p` columns. The
first column keeps track of where the bars should be, the subsequent `p-1` columns
describe the group of bars (possibly stacked) to display at each of these x-axis points.
"""
@with_kw mutable struct Bar2D <: Drawing2D
    xy::Matrix{Float64} # first column x, subsequent columns y1, y2, ...
    barstyle::Vector{BarStyle} # this must be given explicitly see bar!
    # ---
    stacked::Bool = false
    horiz  ::Bool = false
    # ---
    width  ::Option{Float64} = ∅
    # label
end

"""
    Bar2D(xy)

Internal constructor for `Bar2D` object initialising an empty vector of `BarStyle`
of the appropriate size.
"""
function Bar2D(xy::Matrix{Float64})
    n   = size(xy, 2) - 1 # first column is x
    bss = [BarStyle() for i ∈ 1:n]
    Bar2D(xy=xy, barstyle=bss)
end

#=
NOTE
 - if one of the bar is horiz, all are horiz (but shouldn't happen bc shouldnt
 have to assemble stuff
 -
=#
