@with_kw mutable struct Axis
    prefix::String # x, y, x2, y2, z
    ticks ::Ticks  # ticks of the axis
    # ---
    textstyle::TextStyle = TextStyle() # parent textstyle of axis
    # ---
    title ::Option{Title}   = ∅ # title of the axis
    base  ::Option{Float64} = ∅ # scale font and ticks
    lwidth::Option{Float64} = ∅ # width of the axis spine
    min   ::Option{Float64} = ∅ # minimum span of the axis
    max   ::Option{Float64} = ∅ # maximum span of the axis
    # -- toggle-able
    off   ::Option{Bool}    = ∅ # if true, axis is not shown
    log   ::Option{Bool}    = ∅ # log scale
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
    legend::Option{Legend}             = ∅
    # -- toggle-able
    math  ::Option{Bool}               = ∅ # axis crossing (0, 0)
    # ---
    origin::Option{NTuple{2, Float64}} = ∅ # related to layout
end


mutable struct Axes3D{B} <: Axes{B} end # XXX not yet defined

"""
    erase!(axes)

Cleans up `axes` for a new drawing, keeps all other properties the same (ticks, ...).
"""
function erase!(a::Axes2D)
    a.drawings = Vector{Drawing}()
    a.legend   = ∅
    GP_ENV["CURAXES"] = a
    return
end
