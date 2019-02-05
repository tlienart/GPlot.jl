@with_kw mutable struct Axis
    prefix::String # x, y, x2, y2, z
    ticks ::Ticks  # ticks of the axis
    # ---
    textstyle::TextStyle = TextStyle() # parent textstyle of axis
    # ---
    title ::Option{Title}   = ∅ # title of the axis
    off   ::Option{Bool}    = ∅ # if true, axis is not shown
    base  ::Option{Float64} = ∅ # scale font and ticks
    lwidth::Option{Float64} = ∅ # width of the axis spine
    grid  ::Option{Bool}    = ∅ # ? draw ⟂ lines to that axis
    log   ::Option{Bool}    = ∅ # log scale
    min   ::Option{Float64} = ∅ # minimum span of the axis
    max   ::Option{Float64} = ∅ # maximum span of the axis
end
Axis(p::String) = Axis(prefix=p, ticks=Ticks(p))


abstract type Axes{B <: Backend} end


@with_kw mutable struct Axes2D{B} <: Axes{B}
    xaxis ::Axis = Axis("x")
    x2axis::Axis = Axis("x2")
    yaxis ::Axis = Axis("y")
    y2axis::Axis = Axis("y2")
    # ---
    drawings::Vector{Drawing} = Vector{Drawing}()
    # ---
    title ::Option{Title}              = ∅
    size  ::Option{NTuple{2, Float64}} = ∅ # (width cm, height cm)
    math  ::Option{Bool}               = ∅ # axis crossing (0, 0)
    legend::Option{Legend}             = ∅
end


mutable struct Axes3D{B} <: Axes{B} end # XXX not yet defined

"""
    erase!(axes)

Cleans up `axes`.
"""
function erase!(a::Axes2D)
    a.xaxis  = Axis("x")
    a.x2axis = Axis("x2")
    a.yaxis  = Axis("y")
    a.y2axis = Axis("y2")
    a.drawings = Vector{Drawing}()
    clear!(a)
    GP_ENV["CURAXES"] = a
    return
end
