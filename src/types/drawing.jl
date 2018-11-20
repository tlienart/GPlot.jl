abstract type Drawing end
abstract type Drawing2D <: Drawing end

@with_kw struct Line2D <: Drawing2D
    xy::MF
    linestyle  ::LineStyle   = LineStyle()   # GLE ✓
    markerstyle::MarkerStyle = MarkerStyle() # GLE ✓
end
