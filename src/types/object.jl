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
