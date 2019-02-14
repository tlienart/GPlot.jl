@with_kw mutable struct Title
    text::String
    # ---
    textstyle::TextStyle = TextStyle()
    # ---
    dist  ::Option{Float64} = ∅  # distance labels - title
end

@with_kw mutable struct Legend
    # ---
    position::Option{String}  = ∅
    hei     ::Option{Float64} = ∅
    # TODO: can this take a textstyle?
    # offset     ::Option{Tuple{Float, Float}} = ∅
    # entries *not* contained in the struct, they're generated elsewhere
    # nobox      ::Option{Bool}                = ∅
end

@with_kw mutable struct TicksLabels
    names::Option{Vector{String}} = ∅
    # ---
    textstyle::TextStyle = TextStyle()
    # ---
    off   ::Option{Bool}    = ∅ # whether to suppress the labels
    angle ::Option{Float64} = ∅ # rotation of labels
    format::Option{String}  = ∅ # format of the ticks labels
    shift ::Option{Float64} = ∅ # move labels to left/right
    dist  ::Option{Float64} = ∅ # ⟂ distance to spine
end

@with_kw mutable struct Ticks
    labels   ::TicksLabels = TicksLabels() # their label
    linestyle::LineStyle   = LineStyle()   # how the ticks marks look
    # ---
    places   ::Option{Vector{Float64}} = ∅ # where the ticks are
    length   ::Option{Float64}         = ∅ # how long the ticks spine
    # --- toggle-able
    symticks ::Option{Bool}    = ∅ # draws ticks on 2 sides of
    off      ::Option{Bool}    = ∅ # whether to suppress them
    grid     ::Option{Bool}    = ∅ # ticks increased to mirrorred axis
end
Ticks(p::String) = Ticks(prefix=p)
