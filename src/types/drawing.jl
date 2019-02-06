abstract type Drawing end
abstract type Drawing2D <: Drawing end

@with_kw mutable struct Scatter2D{T<:AMR} <: Drawing2D
    xy::T # [x, y1, y2, ...]
    # --- style
    linestyle  ::LineStyle   = LineStyle()
    markerstyle::MarkerStyle = MarkerStyle()
    # --- legend and misc
    label::Option{Union{String, Vector{String}}} = ∅
end

@with_kw mutable struct Fill2D{T<:AMR} <: Drawing2D
    xy1y2::T # [x, y1, y2], fill between y1 and y2
    xmin::Option{Float64} = ∅
    xmax::Option{Float64} = ∅
    # --- style
    fillstyle::FillStyle = FillStyle()
end

@with_kw mutable struct Hist2D{T<:AVR} <: Drawing2D
    x::T
    # --- style
    barstyle::BarStyle = BarStyle()
    # ---
    horiz  ::Bool            = false
    bins   ::Option{Int}     = ∅
    scaling::Option{String}  = ∅
#    label::Option{String} = ∅ # 🚫
end

@with_kw mutable struct GroupedBar2D{T<:AMR} <: Drawing2D
    xy::T # first column x, subsequent columns y1, y2, ...
    barstyle::Vector{BarStyle} # this must be given explicitly see bar!
    # ---
    stacked::Bool = false
    horiz  ::Bool = false
    # ---
    width  ::Option{Float64} = ∅
# label
end

#=
NOTE
 - if one of the bar is horiz, all are horiz (but shouldn't happen bc shouldnt
 have to assemble stuff
 -
=#
