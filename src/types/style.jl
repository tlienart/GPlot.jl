@with_kw mutable struct TextStyle
    font ::Option{String}   = ∅ # GLE ✓
    hei  ::Option{Float}    = ∅ # GLE ✓
    color::Option{Colorant} = ∅ # GLE ✓
end

@with_kw mutable struct LineStyle
    lstyle::Option{Int}     = ∅ # GLE ✓
    lwidth::Option{Float}   = ∅ # GLE ✓
    smooth::Option{Bool}    = ∅ # GLE ✓
    color::Option{Colorant} = ∅ # GLE ✓
end

@with_kw mutable struct MarkerStyle
    marker::Option{String}      = ∅ # GLE ✓
    msize::Option{Float}        = ∅ # GLE ✓
    facecolor::Option{Colorant} = ∅ # GLE ✓
    edgecolor::Option{Colorant} = ∅ # GLE ✓
end
