abstract type Drawing end
abstract type Drawing2D <: Drawing end

@with_kw mutable struct Line2D{T<:MR} <: Drawing2D
    xy::T # first col=x, subs cols = ys
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
    # xmin::Option{Real} = ∅
    # xmax::Option{Real} = ∅
    # --- style
    histstyle::HistStyle = HistStyle() # 🚫
    # --- legend and misc
#    label::Option{String} = ∅ # 🚫
end

# receive a vector x of objects
# number of elements N
#
