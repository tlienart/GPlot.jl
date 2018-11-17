@with_kw mutable struct TextStyle
    font ::Option{String}   = ∅ # font name
    hei  ::Option{Float}    = ∅ # char height
    color::Option{Colorant} = ∅
end

@with_kw struct LineStyle
    lstyle::Int
    lwidth::Option{Int}     = ∅
    smooth::Option{Bool}    = ∅
    color::Option{Colorant} = ∅
end
