@with_kw mutable struct Title
    text     ::AbstractString               # ✓
    textstyle::TextStyle      = TextStyle() # ✓
    # ---
    prefix   ::Option{String} = ∅           # ✓ x, x2, y, y2, z
    dist     ::Option{Float}  = ∅           # ✓ distance labels - title
end


@with_kw mutable struct TicksLabels
    prefix   ::String                       # ✓
    textstyle::TextStyle  = TextStyle()     # ⁠✓ textstyle
    # ---
    off      ::Option{Bool}             = ∅ # ✓ whether to suppress the labels
    angle    ::Option{Float}            = ∅ # ✓ rotation of labels
    format   ::Option{String}           = ∅ # A🚫 format of the ticks labels
    shift    ::Option{Float}            = ∅ # ✓ move labels to left/right
    dist     ::Option{Float}            = ∅ # ✓ ⟂ distance to spine
    names    ::Option{Vector{<:String}} = ∅ # ✓ replaces numeric labeling
end
TicksLabels(p::String) = TicksLabels(prefix=p)


@with_kw mutable struct Ticks
    prefix   ::String                # x, y, x2, y2, z A🚫
    # ---
    off      ::Option{Bool}      = ∅ # whether to suppress them A🚫
    linestyle::Option{LineStyle} = ∅ # how the ticks look A🚫
    length   ::Option{Float}     = ∅ # how long the ticks A🚫
    places   ::Option{VF}        = ∅ # where the ticks are A🚫
    symticks ::Option{Bool}      = ∅ # draws ticks on 2 sides of spine A🚫
end
Ticks(p::String) = Ticks(prefix=p)


@with_kw mutable struct Axis
    prefix     ::String                  # x, y, x2, y2, z A🚫
    ticks      ::Ticks                   # ticks of the axis A🚫
    tickslabels::TicksLabels             # labels of the ticks A🚫
    # ---
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
Axis(p::String) = Axis(prefix=p, ticks=Ticks(p), tickslabels=TicksLabels(p))

@with_kw mutable struct Legend
    # TODO: can this take a textstyle?
    # entries *not* contained in the struct, they're generated elsewhere
    position   ::Option{String} = ∅ # ✓
    # offset     ::Option{Tuple{Float, Float}} = ∅ # 🚫
    hei        ::Option{Float}  = ∅ # ✓
    # nobox      ::Option{Bool}                = ∅ # 🚫
end


abstract type Axes{B<:Backend} end

@with_kw mutable struct Axes2D{B} <: Axes{B}
    xaxis   ::Axis            = Axis("x")  # A🚫
    x2axis  ::Axis            = Axis("x2") # A🚫
    yaxis   ::Axis            = Axis("y")  # A🚫
    y2axis  ::Axis            = Axis("y2") # A🚫
    drawings::Vector{Drawing} = Vector{Drawing}() #
    # ---
    title   ::Option{Title}              = ∅ # A🚫
    size    ::Option{Tuple{Float,Float}} = ∅ # ✓ (width cm, height cm)
    math    ::Option{Bool}               = ∅ # ✓ axis crossing (0, 0)
    legend  ::Option{Legend}             = ∅
end


mutable struct Axes3D{B} <: Axes{B} end


mutable struct Figure{B<:Backend}
    id          ::String             # ✓ unique id of the figure
    g           ::B                  # description stream
    axes        ::Vector{Axes{B}}    # subplots
    size        ::Tuple{Real,Real}   # ✓
    textstyle   ::TextStyle          # ✓
    texlabels   ::Option{Bool}       # ✓ true if has tex
    texscale    ::Option{String}     # ✓ scale latex * hei (def=1)
    texpreamble ::Option{String}     # ✓
    transparency::Option{Bool}       # ✓ if true, use cairo device
end


"""
    Figure(id; opts...)

Return a new `Figure` object with name `id`, if a figure with that name
exists already, return that object.

# Named options:

* `size`: a tuple (width, height) (for rendering prefer sizes ≥ (8, 8) see also fontsize recommendations)
* `font`: a valid font name (note that if you use latex, this is irrelevant)
* `fontsize`: the master font size of the figure in pt (for rendering, prefer fontsizes ≥ 10pt)
* `col`, `color`: the master font color of the figure (any Colors.Colorant can be used)
* `tex`, `hastex`, `latex`, `haslatex`: a boolean indicating whether there is LaTeX to be compiled in the figure
* `texscale`: either `fixed`, `none` or `scale` to match the size of LaTeX expressions to the ambient fontsize (`fixed` and `scale` match, `none` doesn't)
* `preamble`, `texpreamble`: the LaTeX preamble, where you can change the font that is used and also make sure that the symbols you want to use are available.
* `alpha`, `transparent`, `transparency`: a bool indicating whether there may be transparent fillings in which case cairo is used
"""
function Figure(id::String, g::Backend; opts...)
    f = Figure(id, g, Vector{Axes{typeof(g)}}(),
               (12, 9), TextStyle(hei=0.35), ∅, ∅, ∅, ∅)

    set_properties!(f; opts...)
    GP_ALLFIGS[id] = f
    GP_CURFIG.x    = f
    GP_CURAXES.x   = nothing
    return f
end
function Figure(id::String="_fig_"; opts...)
    id == "_fig_" && return Figure(id, GP_BACKEND(); opts...) # a fresh one
    f = get(GP_ALLFIGS, id) do
        Figure(id, GP_BACKEND(); opts...)
    end
    GP_CURFIG.x = f
    GP_CURAXES.x = isempty(f.axes) ? nothing : f.axes[1]
    set_properties!(f; opts...) # f exists but properties have been given
end


"""
    add_axes!(fig, ax)

Add axes `ax` to figure `fig`.
"""
function add_axes!(f::Figure, ax::Axes)
    push!(f.axes, ax)
    GP_CURAXES.x = ax
    return
end

"""
    add_axes2d!()

Add empty `Axes2D` to the current figure.
"""
add_axes2d!() = (f=gcf(); B=get_backend(f); add_axes!(f, Axes2D{B}()))


"""
    erase!(fig)

Replaces `fig`'s current axes by a fresh, empty axes container.
"""
function erase!(f::Figure)
    take!(f.g)
    f.axes = Vector{Axes{typeof(f.g)}}()
    GP_CURFIG.x = f
    GP_CURAXES.x = nothing
    return
end


"""
    isempty(fig)

Return a bool indicating whether `fig` has axes or not.
"""
isempty(fig::Figure) = isempty(fig.axes)
