@with_kw mutable struct Title
    text::String = ""
    # ---
    textstyle::TextStyle = TextStyle()
    # ---
    dist::Option{Float64} = ∅  # distance labels - title
end

@with_kw mutable struct Legend
    # ---
    position::Option{String}   = ∅
    textstyle::TextStyle       = TextStyle()
    offset  ::T2F              = (0.0, 0.0)
    bgcolor ::Option{Colorant} = ∅
    margins ::Option{T2F}      = ∅
    nobox   ::Bool             = false
    off     ::Bool             = false
    # TODO: can this take a textstyle?
    # entries *not* contained in the struct, they're generated elsewhere
    # nobox      ::Option{Bool}                = ∅
end

@with_kw mutable struct TicksLabels
    names::Vector{String} = String[]
    # ---
    textstyle::TextStyle = TextStyle()
    # ---
    angle ::Option{Float64} = ∅ # rotation of labels
    format::Option{String}  = ∅ # format of the ticks labels
    shift ::Option{Float64} = ∅ # move labels to left/right
    dist  ::Option{Float64} = ∅ # ⟂ distance to spine
    # --- toggle-able
    off   ::Bool = false # whether to suppress the labels
end

@with_kw mutable struct Ticks
    labels   ::TicksLabels = TicksLabels() # their label
    linestyle::LineStyle   = LineStyle()   # how the ticks marks look
    # ---
    places   ::Vector{Float64} = Float64[] # where the ticks are
    length   ::Option{Float64} = ∅         # how long the ticks spine
    # --- toggle-able
    symticks ::Bool = false # draws ticks on 2 sides of
    off      ::Bool = false # whether to suppress them
    grid     ::Bool = false # ticks increased to mirrorred axis
end
