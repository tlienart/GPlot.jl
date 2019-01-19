abstract type Drawing end
abstract type Drawing2D <: Drawing end

@with_kw mutable struct Line2D{T<:MR} <: Drawing2D
    xy::T # [x, y1, y2, ...]
    # --- style
    linestyle  ::LineStyle   = LineStyle()   # ✓
    markerstyle::MarkerStyle = MarkerStyle() # ✓
    # --- legend and misc
    label::Option{Union{String, Vector{String}}} = ∅  # ✓
end

@with_kw mutable struct Hist2D{T<:AVR} <: Drawing2D
    x::T
    bins::Option{Int} = ∅ # 🚫
    scaling::Option{String} = ∅ # 🚫
    # --- style
    barstyle::BarStyle = BarStyle() # 🚫
    # --- legend and misc
#    label::Option{String} = ∅ # 🚫
end

@with_kw mutable struct Fill2D{T<:MR} <: Drawing2D
    xy1y2::T # [x, y1, y2], fill between y1 and y2
    xmin::Option{Real} = ∅
    xmax::Option{Real} = ∅
    # --- style
    fillstyle::FillStyle = FillStyle()
end

@with_kw mutable struct Bar2D{T<:MR} <: Drawing2D
    xy::T # first column: x, second y
    # --- style
    barstyle::BarStyle = BarStyle() # 🚫
end

@with_kw mutable struct GroupedBar2D{T<:MR} <: Drawing2D
    xy::T # first column x, subsequent columns y1, y2, ...
    # --- style
    barstyle::Vector{BarStyle} = Vector{BarStyle}()
    stacked::Bool = false # 🚫
# label
end

#=
NOTE
 - if one of the bar is horiz, all are horiz (but shouldn't happen bc shouldnt
 have to assemble stuff
 -
=#
