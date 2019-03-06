"""
    Object

Overarching type for objects displayable on `Axes`.
"""
abstract type Object end

# NOTE: most objects will be <: Object2D
"""
    Object

Overarching type for objects displayable on `Axes2D`.
"""
abstract type Object2D <: Object end

"""
    Text <: Object

Place text somewhere relative to current axes.
"""
@with_kw mutable struct Text2D <: Object2D
    text::String            # what to write
    anchor::T2F             # where the text is located (x,y) position, relative to the axes
    position::String = "cc" # position with respect to anchor (by default centered on anchor)
    textstyle::TextStyle = TextStyle()
end

"""
    StraightLine2D <: Object2D

Place either a vertical or horizontal straightline at given anchor (from axis to axis).
"""
@with_kw mutable struct StraightLine2D <: Object2D
    anchor::Float64
    horiz::Bool
    linestyle::LineStyle = LineStyle()
end


"""
    Box2D <: Object2D

Place a 2D filled box.
"""
@with_kw mutable struct Box2D <: Object2D
    anchor::T2F  # where the box is (in graph units)
    size::T2F    # width, hei (in graph units)
    #
    position::String     = "bl"        # position of the anchor with respect to the box
    nobox::Bool          = true        # show an edge or not
    linestyle::LineStyle = LineStyle() # style of the box edge
    fillstyle::Option{FillStyle} = ∅   # if none --> transparent box
    # text::String
    # textStyle::TextStyle = TextStyle()
end


"""
    Colorbar <: Object2D

Add a colorbar.
"""
@with_kw mutable struct Colorbar <: Object2D
    zmin::Float64
    zmax::Float64
    cmap::Vector{Color}
    # -- optional things
    ticks::Ticks # constructed
    # --
    size::Option{T2F} = ∅ # (width, height)
    # --
    pixels::Int       = 100     # resolution for the color bar
    nobox::Bool       = true    #
    position::String  = "right" # left, right, bottom, top
    offset::T2F       = (0.3, 0.0)
end
Colorbar(zmin::Float64, zmax::Float64, cmap::Vector{<:Color}) =
    Colorbar(zmin=zmin, zmax=zmax, cmap=cmap,
             ticks=Ticks(places=collect(range(zmin,zmax,length=5))[2:end-1]))
