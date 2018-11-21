@with_kw mutable struct TextStyle
    font ::Option{String}   = ∅ # ✓
    hei  ::Option{Float}    = ∅ # ✓
    color::Option{Colorant} = ∅ # ✓
end

@with_kw mutable struct LineStyle
    lstyle::Option{Int}      = ∅ # ✓
    lwidth::Option{Float}    = ∅ # ✓
    smooth::Option{Bool}     = ∅ # ✓
    color ::Option{Colorant} = ∅ # ✓
end

@with_kw mutable struct MarkerStyle
    marker::Option{String} = ∅ # ✓
    msize::Option{Float}   = ∅ # ✓
    color::Option{Color}   = ∅ # ✓
end
