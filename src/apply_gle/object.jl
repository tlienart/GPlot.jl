"""
    apply_objects!(g, objects)

Internal function to apply a vector of `Object` contained in an `Axes` container in a GLE context.
"""
apply_objects!(g::GLE, objects::Vector{<:Object}) = (foreach(o -> apply_object!(g, o), objects); ∅)

function apply_object!(g::GLE, obj::Text2D)
    "\ngsave"    |> g
    "\nset just $(obj.position)"                        |> g
    apply_textstyle!(g, obj.textstyle, addset=true)
    "\namove xg($(obj.anchor[1])) yg($(obj.anchor[2]))" |> g
    "\nwrite \"$(obj.text)\""                           |> g
    "\ngrestore" |> g
    return nothing
end

function apply_object!(g::GLE, obj::StraightLine2D)
    "\ngsave"    |> g
    if obj.horiz
        "\namove xg(xgmin) yg($(obj.anchor))" |> g
        "\naline xg(xgmax) yg($(obj.anchor))" |> g
    else
        "\namove xg($(obj.anchor)) yg(ygmin)" |> g
        "\naline xg($(obj.anchor)) yg(ygmax)" |> g
    end
    "\ngrestore" |> g
    return nothing
end
