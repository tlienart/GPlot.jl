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
    color::Option{Color} = ∅ #
    fill::Colorant       = colorant"white" #
#   pattern::Option{String}   =  .... see page 39 of manual, test first
end

@with_kw mutable struct FillStyle
    fill::Colorant = colorant"cornflowerblue"
end

mutable struct BoxplotStyle
end


"""
    str(m::MarkerStyle)

Internal function to help in the specific case where a line with markers of different
color than the line is required. In that case a subroutine has to be written to help
GLE, see [`add_sub_marker!`](@ref).
"""
str(m::MarkerStyle) = "marker_$(m.marker)_$(col2str(m.color; str=true))"


str(b::BoxplotStyle) = "draw_boxplot_"
