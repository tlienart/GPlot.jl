
####
#### legend!, legend
####

"""
    $SIGNATURES

Update the properties of an existing legend object present on `axes`. If none
exist then a new one is created with the given properties.
"""
function legend!(vd::Option{Vector{DrawingHandle{T}}}=nothing,
                 labels::Option{Vector{Union{String,Vector{String}}}}=nothing;
                 axes=nothing, overwrite=false, opts...) where T
    axes=check_axes(axes)
    # if there exists a legend object but overwrite, then reset it
    (!isdef(axes.legend) || overwrite) && (axes.legend = Legend())
    if isnothing(vd)
        isnothing(labels) || throw(ArgumentError("Cannot pass labels without handles."))
        axes.legend.handles = [DrawingHandle(d) for d ∈ axes.drawings]
        axes.legend.labels = fill("", length(axes.drawings))
        s_ctr = 1
        f_ctr = 1
        h_ctr = 1
        b_ctr = 1
        for (k,d) ∈ enumerate(axes.drawings)
            if d isa Scatter2D
                if isempty(d.labels)
                    axes.legend.labels[k] = ["plot $(s_ctr+e-1)" for e ∈ 1:d.nobj]
                else
                    axes.legend.labels[k] = d.labels
                end
                s_ctr += d.nobj
            elseif d isa Fill2D
                if isempty(d.label)
                    axes.legend.labels[k] = "fill $f_ctr"
                else
                    axes.legend.labels[k] = d.label
                end
                f_ctr += 1
            elseif d isa Hist2D
                if isempty(d.label)
                    axes.legend.labels[k] = "hist $h_ctr"
                else
                    axes.legend.labels[k] = d.label
                end
                h_ctr += 1
            elseif d isa Bar2D
                if isempty(d.labels)
                    axes.legend.labels[k] = ["bar $(b_ctr+e-1)" for e ∈ 1:d.nobj]
                else
                    axes.legend.labels[k] = d.labels
                end
                b_ctr += d.nobj
            end
        end
    else
        isnothing(labels) && throw(ArgumentError("Labels must be provided along with handles"))
        length(vd) == length(labels) || throw(ArgumentError("There must be as many labels given "*
                                                            "as drawing handles"))
        axes.legend.handles = vd
        axes.legend.labels  = labels
    end
    set_properties!(axes.legend; defer_preview=true, opts...)
    return preview()
end

"""
    legend(; options...)

Creates a new legend object on the current axes with the given options.
If one already exist, it will be destroyed and replaced by this one.
"""
legend(a...; o...) = legend!(a...; overwrite=true, o...)
