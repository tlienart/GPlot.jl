"""
    cll()

Clears the current legend.
"""
cll() = (reset!(gca().legend); PreviewFigure(gcf()))

"""
    $SIGNATURES

Update the properties of an existing legend object present on `axes`. If none
exist then a new one is created with the given properties.
"""
function legend(vd::Option{Vector{DrawingHandle{T}}}=nothing,
                 labels::Option{Vector{<:Union{String,Vector{String}}}}=nothing;
                 axes=nothing, opts...) where T
    axes isa Axes3D && throw(NotImplementedError("Legend for Axes3D"))
    axes=check_axes(axes)
    # create a new legend object
    axes.legend = Legend()
    # check if handles are given, if none, try to apply a default legend
    if isnothing(vd)
        isnothing(labels) || throw(ArgumentError("Cannot pass labels without handles."))
        axes.legend.handles = [DrawingHandle(d) for d ∈ axes.drawings]
        axes.legend.labels  = fill("", length(axes.drawings))

        # check if any object has a label, otherwise fill with default
        onehaslabel = false
        for (k,d) ∈ enumerate(axes.drawings)
            if isa(d, Union{Scatter2D,Bar2D})
                isempty(d.labels) || (axes.legend.labels[k] = d.labels; onehaslabel = true)
            elseif isa(d, Union{Fill2D, Hist2D})
                isempty(d.label)  || (axes.legend.labels[k] = d.label; onehaslabel = true)
            end
        end
        if onehaslabel
            # remove the entries that don't have a label
            mask = .!(isempty.(axes.legend.labels))
            axes.legend.handles = axes.legend.handles[mask]
            axes.legend.labels  = axes.legend.labels[mask]
        else
            s_ctr = 1
            f_ctr = 1
            h_ctr = 1
            b_ctr = 1
            for (k,d) ∈ enumerate(axes.drawings)
                if d isa Scatter2D
                    axes.legend.labels[k] = ["plot $(s_ctr+e-1)" for e ∈ 1:d.nobj]
                    s_ctr += d.nobj
                elseif d isa Fill2D
                    axes.legend.labels[k] = "fill $f_ctr"
                    f_ctr += 1
                elseif d isa Hist2D
                    axes.legend.labels[k] = "hist $h_ctr"
                    h_ctr += 1
                elseif d isa Bar2D
                    axes.legend.labels[k] = ["bar $(b_ctr+e-1)" for e ∈ 1:d.nobj]
                    b_ctr += d.nobj
                end
            end
        end
    # handles are given, check the labels
    else
        isnothing(labels) && throw(ArgumentError("Labels must be provided along with handles"))
        length(vd) == length(labels) || throw(ArgumentError("There must be as many labels given "*
                                                            "as drawing handles"))
        axes.legend.handles = vd
        axes.legend.labels  = labels
    end
    set_properties!(axes.legend; defer_preview=true, opts...)
    return PreviewFigure(gcf())
end
legend(d::DrawingHandle{T}, s::String; o...) where T = legend([d],[s]; o...)
