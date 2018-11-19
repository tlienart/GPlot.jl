@with_kw mutable struct TextStyle
    font ::Option{String}   = ∅ # font name
    hei  ::Option{Float}    = ∅ # char height
    color::Option{Colorant} = ∅
end

@with_kw mutable struct LineStyle
    lstyle::Option{Int}     = ∅
    lwidth::Option{Float}   = ∅
    smooth::Option{Bool}    = ∅
    color::Option{Colorant} = ∅
end

@with_kw mutable struct MarkerStyle
    marker::Option{String}      = ∅
    msize::Option{Float}        = ∅
    facecolor::Option{Colorant} = ∅
    edgecolor::Option{Colorant} = ∅
end
