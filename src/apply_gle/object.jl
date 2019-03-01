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
    apply_linestyle!(g, obj.linestyle; addset=true)
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

function apply_object!(g::GLE, obj::Box2D)
    "\ngsave" |> g
    obj.position == "bl" || "\nset just $(obj.position)"      |> g
    apply_linestyle!(g, obj.linestyle; addset=true)
    "\namove xg($(obj.anchor[1])) yg($(obj.anchor[2]))"       |> g
    "\nbox xg($(obj.size[1]))-xg(0) yg($(obj.size[2]))-yg(0)" |> g
    obj.nobox && "nobox"                    |> g
    fs = obj.fillstyle
    isdef(fs) && "fill $(col2str(fs.fill))" |> g
    "\ngrestore" |> g
    return nothing
end

function apply_object!(g::GLE, obj::Heatmap)
    "\ngsave"           |> g
    nrows, ncols = size(obj.data)
    ncolors = length(obj.colormap)
    minv  = minimum(obj.data)
    maxv  = maximum(obj.data)
    incr  = (maxv - minv) / ncolors
    zcols = Matrix{Int}(undef, nrows, ncols)
    if iszero(incr)
        zcols .= ceil(ncols/2)
    else
        @inbounds for i=1:nrows, j=1:ncols
            zcols[i, j] = ceil(Integer, (obj.data[i, j] - minv) / incr)
        end
    end

    zcols[zcols .== 0] .= 1

    for i=1:nrows, j=1:ncols
        "\namove xg($((j-1)/ncols)) yg($(1-i/nrows))"       |> g
        "\nbox xg($(1/ncols))-xg(0) yg($(1/nrows))-yg(0)"   |> g
        # styling
        "nobox fill $(col2str(obj.colormap[zcols[i,j]]))"   |> g
    end
    "\ngrestore"  |> g
end
