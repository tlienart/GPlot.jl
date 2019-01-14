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
