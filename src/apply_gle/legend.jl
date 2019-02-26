"""
    apply_legend_spec!(...)

Internal helper functions to apply the legend element corresponding to a specific drawing
handle.
"""
function apply_legend_spec!(g::GLE, h::DrawingHandle{Scatter2D{T}},
                            labels::Union{String,Vector{String}}, figid::String) where T
    scatter = h.drawing
    labels isa Vector || (labels = fill(labels, scatter.nobj))
    for k ∈ 1:scatter.nobj
        "\n\ttext \"$(labels[k])\"" |> g
        if scatter.linestyles[k].lstyle != 1
            # line plot
            "line" |> g; apply_linestyle!(g, scatter.linestyles[k], legend=true)
            mcol_flag = false
            if isdef(scatter.markerstyles[k].color) &&
                    (scatter.markerstyles[k].color != scatter.linestyles[k].color)
                mcol_flag = true
                add_sub_marker!(Figure(figid; _noreset=true), scatter.markerstyles[k])
            end
            # apply markerstyle
            apply_markerstyle!(g, scatter.markerstyles[k], mcol_flag=mcol_flag)
        else
            # scatter plot
            if !isdef(scatter.markerstyles[k].color)
                scatter.markerstyles[k].color = scatter.linestyles[k].color
            end
            apply_markerstyle!(g, scatter.markerstyles[k])
        end
    end
    return nothing
end
function apply_legend_spec!(g::GLE, h::DrawingHandle{Fill2D{T}},
                            label::String, ::String) where T
    fill = h.drawing
    "\n\ttext \"$label\" fill $(col2str(fill.fillstyle.fill))" |> g
    return nothing
end
function apply_legend_spec!(g::GLE, h::DrawingHandle{Hist2D{T}},
                            label::String, ::String) where T
    hist = h.drawing
    "\n\ttext \"$label\"" |> g
    # precedence of fill over color
    if hist.barstyle.fill != colorant"white"
        "fill $(col2str(hist.barstyle.fill))" |> g
    else
        "marker square color $(col2str(hist.barstyle.color))" |> g
    end
    return nothing
end
function apply_legend_spec!(g::GLE, h::DrawingHandle{Bar2D{T}},
                            labels::Union{String,Vector{String}}, ::String) where T
    bar = h.drawing
    labels isa Vector || (labels = fill(labels, bar.nobj))
    for (k, barstyle) ∈ enumerate(bar.barstyles)
        "\n\ttext \"$(labels[k])\"" |> g
        if barstyle.fill != colorant"white"
            "fill $(col2str(barstyle.fill))" |> g
        else
            "marker square color $(col2str(barstyle.color))" |> g
        end
    end
    return nothing
end

"""
    apply_legend!(g, leg, parent_font)

Internal function to apply a `Legend` object `leg` in a GLE context with entries
`entries` (constructed through the `apply_drawings` process).
"""
function apply_legend!(g::GLE, l::Legend, parent_font::String, figid::String)
    l.off && return nothing
    isempty(l.handles) && return nothing
    "\ngsave" |> g
    apply_textstyle!(g, l.textstyle, parent_font; addset=true)

    # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "\nbegin key"  |> g

    # global commands
    "\n\tcompact"      |> g
    l.nobox && "nobox" |> g
    isdef(l.bgcolor)  && "background $(col2str(l.bgcolor))"        |> g
    isdef(l.margins)  && "margins $(l.margins[1]) $(l.margins[2])" |> g
    sum(l.offset)>0   && "offset $(l.offset[1]) $(l.offset[2])"    |> g
    isdef(l.position) && "\n\tposition $(l.position)"              |> g

    for (handle, label) ∈ zip(l.handles, l.labels)
        apply_legend_spec!(g, handle, label, figid)
    end
    #
    "\nend key"    |> g
    # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    "\ngrestore" |> g
    return nothing
end
