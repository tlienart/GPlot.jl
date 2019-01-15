abstract type Drawing end
abstract type Drawing2D <: Drawing end

@with_kw mutable struct Line2D{T<:MR} <: Drawing2D
    xy::T # first col=x, subs cols = ys
    # --- style
    linestyle  ::LineStyle   = LineStyle()   # ✓
    markerstyle::MarkerStyle = MarkerStyle() # ✓
<<<<<<< HEAD
    # --- legend and misc
    label::Option{Union{String, Vector{String}}} = ∅  # ✓
=======
    # ---
    label      ::Option{String} = ∅          # ✓
>>>>>>> wip-china
end
