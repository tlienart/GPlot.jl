@with_kw mutable struct Title
    text     ::AbstractString               # ✓
    textstyle::TextStyle      = TextStyle() # ✓
    # ---
    prefix   ::Option{String} = ∅           # ✓ x, x2, y, y2, z
    dist     ::Option{Real}   = ∅           # ✓ distance labels - title
end


@with_kw mutable struct TicksLabels
    prefix   ::String                       # ✓
    textstyle::TextStyle  = TextStyle()     # ⁠✓ textstyle
    # ---
    off      ::Option{Bool}             = ∅ # ✓ whether to suppress the labels
    angle    ::Option{Real}             = ∅ # ✓ rotation of labels
    format   ::Option{String}           = ∅ # A🚫 format of the ticks labels
    shift    ::Option{Real}             = ∅ # ✓ move labels to left/right
    dist     ::Option{Real}             = ∅ # ✓ ⟂ distance to spine
    names    ::Option{Vector{<:String}} = ∅ # ✓ replaces numeric labeling
end
TicksLabels(p::String) = TicksLabels(prefix=p)


@with_kw mutable struct Ticks
    prefix   ::String                # x, y, x2, y2, z A🚫
    # ---
    off      ::Option{Bool}      = ∅ # whether to suppress them A🚫
    linestyle::Option{LineStyle} = ∅ # how the ticks look A🚫
    length   ::Option{Real}      = ∅ # how long the ticks A🚫
    places   ::Option{AVR}       = ∅ # where the ticks are A🚫
    symticks ::Option{Bool}      = ∅ # draws ticks on 2 sides of spine A🚫
end
Ticks(p::String) = Ticks(prefix=p)


@with_kw mutable struct Legend
    # TODO: can this take a textstyle?
    # entries *not* contained in the struct, they're generated elsewhere
    position   ::Option{String} = ∅ # ✓
    # offset     ::Option{Tuple{Float, Float}} = ∅ # 🚫
    hei        ::Option{Real}  = ∅ # ✓
    # nobox      ::Option{Bool}                = ∅ # 🚫
end
