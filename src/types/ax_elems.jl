@with_kw mutable struct Title
    text     ::AbstractString               # ✓
    textstyle::TextStyle      = TextStyle() # ✓
    # ---
    prefix   ::Option{String} = ∅           # ✓ x, x2, y, y2, z
    dist     ::Option{Real}   = ∅           # ✓ distance labels - title
end

@with_kw mutable struct Legend
    # TODO: can this take a textstyle?
    # entries *not* contained in the struct, they're generated elsewhere
    position::Option{String} = ∅ # ✓
    # offset     ::Option{Tuple{Float, Float}} = ∅ # 🚫
    hei     ::Option{Real}  = ∅ # ✓
    # nobox      ::Option{Bool}                = ∅ # 🚫
end

@with_kw mutable struct TicksLabels
    names    ::Option{Vector{String}} = ∅ # ✓ replaces numeric labeling
    # ---
    textstyle::TextStyle = TextStyle()     # ⁠✓ textstyle
    # ---
    off      ::Option{Bool}           = ∅ # ✓ whether to suppress the labels
    angle    ::Option{Real}           = ∅ # ✓ rotation of labels
    format   ::Option{String}         = ∅ # A🚫 format of the ticks labels
    shift    ::Option{Real}           = ∅ # ✓ move labels to left/right
    dist     ::Option{Real}           = ∅ # ✓ ⟂ distance to spine
end

@with_kw mutable struct Ticks
    prefix   ::String                      # x, y, x2, y2, z A🚫
    # ---
    places   ::Option{AVR}  = ∅             # where the ticks are A🚫
    labels   ::TicksLabels  = TicksLabels() # their label
    # ---
    off      ::Option{Bool} = ∅             # whether to suppress them A🚫
    linestyle::LineStyle    = LineStyle()   # how the ticks look A🚫
    length   ::Option{Real} = ∅             # how long the ticks A🚫
    symticks ::Option{Bool} = ∅             # draws ticks on 2 sides of spine
end
Ticks(p::String) = Ticks(prefix=p)
