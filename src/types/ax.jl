@with_kw mutable struct Axis
    prefix     ::String   # x, y, x2, y2, z A🚫
    ticks      ::Ticks    # ticks of the axis A🚫
    # ---
    title      ::Option{Title}     = ∅ # title of the axis A🚫
    off        ::Option{Bool}      = ∅ # if true, axis is not shown A🚫
    base       ::Option{Real}      = ∅ # scale font and ticks A🚫
    textstyle  ::Option{TextStyle} = ∅ # parent textstyle of axis A🚫
    lwidth     ::Option{Real}      = ∅ # width of the axis spine A🚫
    grid       ::Option{Bool}      = ∅ # ? draw ⟂ lines to that axis A🚫
    log        ::Option{Bool}      = ∅ # ✓ log scale
    min        ::Option{Real}      = ∅ # ✓ minimum span of the axis
    max        ::Option{Real}      = ∅ # ✓ maximum span of the axis
end
Axis(p::String) = Axis(prefix=p, ticks=Ticks(p))


abstract type Axes{B <: Backend} end


@with_kw mutable struct Axes2D{B} <: Axes{B}
    xaxis   ::Axis            = Axis("x")  # A🚫
    x2axis  ::Axis            = Axis("x2") # A🚫
    yaxis   ::Axis            = Axis("y")  # A🚫
    y2axis  ::Axis            = Axis("y2") # A🚫
    drawings::Vector{Drawing} = Vector{Drawing}() #
    # ---
    title   ::Option{Title}            = ∅ # A🚫
    size    ::Option{Tuple{Real,Real}} = ∅ # ✓ (width cm, height cm)
    math    ::Option{Bool}             = ∅ # ✓ axis crossing (0, 0)
    legend  ::Option{Legend}           = ∅
end

mutable struct Axes3D{B} <: Axes{B} end # XXX not yet defined


"""
    erase!(axes)

Cleans up `axes`.
"""
function erase!(a::Axes2D)
    a.xaxis    = Axis("x")
    a.x2axis   = Axis("x2")
    a.yaxis    = Axis("y")
    a.y2axis   = Axis("y2")
    a.drawings = Vector{Drawing}()
    clear!(a)
    GP_ENV["CURAXES"] = a
    return
end
