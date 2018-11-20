@with_kw mutable struct Title
    text     ::String                # GLE ✓
    prefix   ::Option{String}    = ∅ # x, x2, y, y2, z GLE ✓
    textstyle::Option{TextStyle} = ∅ # GLE ✓
    dist     ::Option{Float}     = ∅ # distance labels - title GLE ✓
end


@with_kw mutable struct TicksLabels
    prefix   ::String                     # A🚫
    off      ::Option{Bool}           = ∅ # whether to suppress the labels A🚫
    textstyle::Option{TextStyle}      = ∅ # textstyle A🚫
    angle    ::Option{Float}          = ∅ # rotation of labels A🚫
    format   ::Option{String}         = ∅ # format of the ticks labels A🚫
    shift    ::Option{Float}          = ∅ # move labels to left/right A🚫
    dist     ::Option{Float}          = ∅ # ⟂ distance to spine A🚫
    names    ::Option{Vector{String}} = ∅ # replaces numeric labeling A🚫
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
    xaxis   ::Axis                       = Axis("x")         # ✓
    x2axis  ::Axis                       = Axis("x2")        # ✓
    yaxis   ::Axis                       = Axis("y")         # ✓
    y2axis  ::Axis                       = Axis("y2")        # ✓
    drawings::Vector{Drawing}            = Vector{Drawing}() #
    title   ::Option{Title}              = ∅                 # ✓
    size    ::Option{Tuple{Float,Float}} = ∅                 # ✓
end


mutable struct Axes3D <: Axes end


@with_kw mutable struct Figure{B<:Backend}
    id::String                # unique identifier of the figure
    g::B
    axes::Vector{Axes} = Vector{Axes}() # all the subplots (≥1)
    # options
    size     ::Tuple{Float,Float} = (8., 6.) # ✓
    textstyle::TextStyle          = TextStyle(font="psh", hei=0.2) # ✓
    texlabels::Option{Bool}       = ∅ # true if has tex ✓
    texscale ::Option{Float}      = ∅ # scale latex to scale * hei (def=1) ✓
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
