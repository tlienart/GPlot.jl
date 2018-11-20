@with_kw mutable struct Title
    text     ::String                # ✓
    prefix   ::Option{String}    = ∅ # ✓ x, x2, y, y2, z
    textstyle::Option{TextStyle} = ∅ # ✓
    dist     ::Option{Float}     = ∅ # ✓ distance labels - title
end


@with_kw mutable struct TicksLabels
    prefix   ::String                     # ✓
    off      ::Option{Bool}           = ∅ # ✓ whether to suppress the labels
    textstyle::Option{TextStyle}      = ∅ # ⁠✓ textstyle
    angle    ::Option{Float}          = ∅ # ✓ rotation of labels
    format   ::Option{String}         = ∅ # A🚫 format of the ticks labels
    shift    ::Option{Float}          = ∅ # ✓ move labels to left/right
    dist     ::Option{Float}          = ∅ # ✓ ⟂ distance to spine
    names    ::Option{Vector{String}} = ∅ # ✓ replaces numeric labeling
end
TicksLabels(p) = TicksLabels(prefix=p)


@with_kw mutable struct Ticks
    prefix   ::String                # x, y, x2, y2, z A🚫
    off      ::Option{Bool}      = ∅ # whether to suppress them A🚫
    linestyle::Option{LineStyle} = ∅ # how the ticks look A🚫
    length   ::Option{Float}     = ∅ # how long the ticks A🚫
    places   ::Option{VF}        = ∅ # where the ticks are A🚫
    symticks ::Option{Bool}      = ∅ # draws ticks on 2 sides of spine A🚫
end
Ticks(p) = Ticks(prefix=p)


@with_kw mutable struct Axis
    prefix     ::String                  # x, y, x2, y2, z A🚫
    ticks      ::Ticks                   # ticks of the axis A🚫
    tickslabels::TicksLabels             # labels of the ticks A🚫
    title      ::Option{Title}     = ∅ # title of the axis A🚫
    off        ::Option{Bool}      = ∅ # if true, axis is not shown A🚫
    base       ::Option{Float}     = ∅ # scale font and ticks A🚫
    textstyle  ::Option{TextStyle} = ∅ # parent textstyle of axis A🚫
    lwidth     ::Option{Float}     = ∅ # width of the axis spine A🚫
    grid       ::Option{Bool}      = ∅ # ? draw ⟂ lines to that axis A🚫
    log        ::Option{Bool}      = ∅ # log scale A🚫
    min        ::Option{Float}     = ∅ # minimum span of the axis A🚫
    max        ::Option{Float}     = ∅ # maximum span of the axis A🚫
end
Axis(p) = Axis(prefix=p, ticks=Ticks(p), tickslabels=TicksLabels(p))


abstract type Axes end


@with_kw mutable struct Axes2D <: Axes
    xaxis   ::Axis                       = Axis("x")  # A🚫
    x2axis  ::Axis                       = Axis("x2") # A🚫
    yaxis   ::Axis                       = Axis("y")  # A🚫
    y2axis  ::Axis                       = Axis("y2") # A🚫
    drawings::Vector{Drawing}            = Vector{Drawing}() #
    title   ::Option{Title}              = ∅ # A🚫
    size    ::Option{Tuple{Float,Float}} = ∅ # ✓ (width cm, height cm)
    math    ::Option{Bool}               = ∅ # ✓ axis crossing (0, 0)
end


mutable struct Axes3D <: Axes end


@with_kw mutable struct Figure{B<:Backend}
    id::String                # unique identifier of the figure
    g::B
    axes::Vector{Axes}               = [Axes()] # all the subplots (≥1)
    # options
    size        ::Tuple{Float,Float} = (8., 6.) # A🚫
    textstyle   ::TextStyle          = TextStyle(font="psh", hei=0.2) # A🚫
    texlabels   ::Option{Bool}       = ∅ # true if has tex A🚫
    texscale    ::Option{Float}      = ∅ # scale latex * hei (def=1) A🚫
    transparency::Option{Bool}       = ∅ # if true, use cairo device 🚫
end


function Figure(id, g)
    GP_CURFIG.x = id
    λ = Figure(id=id, g=g)
    GP_ALLFIGS[id] = λ
    return λ
end
Figure() = Figure("fig_" * randstring(3))


function Figure(id::String)
    get(GP_ALLFIGS, id) do
        Figure(id, GP_BACKEND())
    end
end


erase!(fig::Figure) = (take!(fig.g); fig.axes=Vector{Axes}(); fig)
