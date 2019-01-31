@with_kw mutable struct TextStyle
    font ::Option{String}   = ∅ # ✓
    hei  ::Option{Float64}  = ∅ # ✓
    color::Option{Colorant} = ∅ # ✓
end

@with_kw mutable struct LineStyle
    lstyle::Option{Int}      = ∅ # ✓
    lwidth::Option{Float64}  = ∅ # ✓
    smooth::Option{Bool}     = ∅ # ✓
    color ::Option{Colorant} = ∅ # ✓
end

@with_kw mutable struct MarkerStyle
    marker::Option{String} = ∅ # ✓
    msize::Option{Float64} = ∅ # ✓
    color::Option{Color}   = ∅ # ✓
end

@with_kw mutable struct BarStyle
    color::Option{Color} = ∅ # ✓
    fill::Option{Color}  = ∅ # ✓
#    horiz::Option{Bool}      = ∅ # ✓
#   pattern::Option{String}   =  .... see page 39 of manual, test first
#   width ...
end

@with_kw mutable struct FillStyle
    color::Union{Color, TransparentColor} = colorant"cornflowerblue"
end
