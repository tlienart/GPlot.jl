abstract type Drawing end
abstract type Drawing2D <: Drawing end

@with_kw struct Markers
    marker::String
    color::Option{Colorant} = ∅
    msize::Option{Float}    = ∅
end

@with_kw struct Line2D <: Drawing2D
    xy::MF
    lstyle::Option{LineStyle} = ∅ # MAN p103, if nothing -> no line
    markers::Option{Markers}  = ∅
end
