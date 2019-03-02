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
