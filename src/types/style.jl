@with_kw mutable struct TextStyle
    font ::Option{String}  = ∅ #
    hei  ::Option{Float64} = ∅ #
    color::Option{Color}   = ∅ #
end

@with_kw mutable struct LineStyle
    lstyle::Option{Int}     = ∅ #
    lwidth::Option{Float64} = ∅ #
    smooth::Option{Bool}    = ∅ #
    color ::Option{Color}   = ∅ #
end

@with_kw mutable struct MarkerStyle
    marker::Option{String} = ∅ #
    msize::Option{Float64} = ∅ #
    color::Option{Color}   = ∅ #
end

@with_kw mutable struct BarStyle
    color::Option{Color}    = ∅ #
    fill::Colorant          = c"white" #
#   pattern::Option{String}   =  .... see page 39 of manual, test first
end

@with_kw mutable struct FillStyle
    fill::Colorant = c"cornflowerblue"
end

@with_kw mutable struct BoxplotStyle
    # box and whisker styling
    bwidth::Float64   = 0.6 # width of the box
    wwidth::Float64   = 0.3 # width of the whiskers
    wrlength::Float64 = 1.5 # whisker length is wrlength * IQR, if INF will be min-max
    blstyle::LineStyle = LineStyle(lstyle=1, lwidth=0, color=c"black")
    # median
    mlstyle::LineStyle = LineStyle(lstyle=1, lwidth=0, color=c"seagreen")
    # mean
    mshow::Bool          = true
    mmstyle::MarkerStyle = MarkerStyle(marker="fdiamond", msize=.4, color=c"dodgerblue")
    # outliers
    oshow::Bool          = true
    omstyle::MarkerStyle = MarkerStyle(marker="+", msize=.5, color=c"tomato")
end


"""
    str(m::MarkerStyle)

Internal function to help in the specific case where a line with markers of different
color than the line is required. In that case a subroutine has to be written to help
GLE, see [`add_sub_marker!`](@ref).
"""
str(m::MarkerStyle) = "mk_$(m.marker)_$(col2str(m.color; str=true))"
