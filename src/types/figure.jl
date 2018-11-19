@with_kw mutable struct Title
    title    ::String                # ✓
    prefix   ::Option{String}    = ∅ # x, x2, y, y2, z ✓
    textstyle::Option{TextStyle} = ∅ # ✓
    dist     ::Option{Float}     = ∅ # distance between labels and title ✓
end

@with_kw mutable struct TicksLabels
    prefix   ::String                     # ✓
    off      ::Option{Bool}           = ∅ # whether to suppress the labels ✓
    textstyle::Option{TextStyle}      = ∅ # textstyle ✓
    angle    ::Option{Float}          = ∅ # rotation of labels ✓
    format   ::Option{String}         = ∅ # format of the ticks labels ✓
    shift    ::Option{Float}          = ∅ # move labels to left/right ✓
    dist     ::Option{Float}          = ∅ # ⟂ distance to spine ✓
    names    ::Option{Vector{String}} = ∅ # replaces numeric labeling ✓
end
TicksLabels(p) = TicksLabels(prefix=p)

@with_kw mutable struct Ticks
    prefix   ::String                     # x, y, x2, y2, z ✓
    off      ::Option{Bool}      = ∅ # whether to suppress them ✓
    linestyle::Option{LineStyle} = ∅ # how the ticks look ✓
    length   ::Option{Float}     = ∅ # how long the ticks ✓
    places   ::Option{VF}        = ∅ # where the ticks are ✓
    symticks ::Option{Bool}      = ∅ # draws ticks on 2 sides of spine ✓
end
Ticks(p) = Ticks(prefix=p)

@with_kw mutable struct Axis
    prefix     ::String                  # x, y, x2, y2, z
    ticks      ::Ticks                   # ticks of the axis ✓
    tickslabels::TicksLabels             # labels of the ticks ✓
    title      ::Option{Title}     = ∅ # title of the axis ✓
    off        ::Option{Bool}      = ∅ # if true, axis is not shown ✓
    base       ::Option{Float}     = ∅ # scale font and ticks ✓
    textstyle  ::Option{TextStyle} = ∅ # parent textstyle of axis ✓
    lwidth     ::Option{Float}     = ∅ # width of the axis spine ✓
    grid       ::Option{Bool}      = ∅ # ? draw ⟂ lines to that axis ✓
    log        ::Option{Bool}      = ∅ # log scale ✓
    min        ::Option{Float}     = ∅ # minimum span of the axis ✓
    max        ::Option{Float}     = ∅ # maximum span of the axis ✓
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
    texscale ::Option{Float}      = ∅ # scale latex to scale * hei (default=1)
    texlabels::Option{Int}        = ∅ # 1 if has tex
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
