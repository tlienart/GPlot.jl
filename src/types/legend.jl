@with_kw mutable struct Legend
    handles::Vector{DrawingHandle} = DrawingHandle[]
    labels::Vector{Union{String,Vector{String}}} = String[]
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
