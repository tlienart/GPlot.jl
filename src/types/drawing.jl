abstract type Drawing end
abstract type Drawing2D <: Drawing end

@with_kw mutable struct Line2D <: Drawing2D
    xy::MF
    linestyle  ::LineStyle   = LineStyle()   # ✓
    markerstyle::MarkerStyle = MarkerStyle() # ✓
    # ---
    label      ::Option{String} = ∅          # ✓
end
