####
#### [x|y|x2|y2]title[!]
####

"""
    $SIGNATURES

Internal function to set the title of axes (`el==:title`) or axis objects (`el==:xtitle`...).
"""
function _title!(el::Symbol, text::String="";
                 axes=nothing, overwrite=false, opts...)
    axes = check_axes(axes)
    # retrieve on what object to apply the title either the current axes or a sub-axis
    obj = (el == :axis) ? axes : getfield(axes, el)
    if isdef(obj.title)
        # if overwrite, clear the current title
        overwrite && (obj.title = Title())
        obj.title.text = ifelse(isempty(text), obj.title.text, text)
    else # title doesn't exist, create one
        obj.title = Title(text=text)
    end
    set_properties!(obj.title; defer_preview=true, opts...)
    return _preview()
end

# Generate xlim!, xlim, and associated for each axis
for axs ∈ ("", "x", "y", "x2", "y2")
    f!  = Symbol(axs * "title!")
    f   = Symbol(axs * "title")
    f2! = Symbol(axs * "label!") # synonyms xlabel = xtitle
    f2  = Symbol(axs * "label")
    ex = quote
        # mutate
        $f!(t::String=""; o...) = _title!(Symbol($axs * "axis"), t; axes=gca(), o...)
        # overwrite
        $f(a...; o...) = $f!(a...; overwrite=true, o...)
        # more synonyms xlabel, ylabel, etc
        !isempty($axs) && ($f2! = $f!; $f2 = $f)
    end
    eval(ex)
end

####
#### [x|y|x2|y2]ticks
####

function _ticks!(axis_sym::Symbol, loc::Vector{Float64}=Float64[], lab::Vector{String}=String[];
                 axes=nothing, overwrite=false, opts...)
    axes = check_axes(axes)
    # retrieve the appropriate axis
    axis = getfield(axes, axis_sym)
    # if overwrite, clear the current ticks object
    overwrite && (axis.ticks = Ticks())
    # if locs are empty, just pass options and return
    if isempty(loc)
        isempty(lab) || throw(ArgumentError("Cannot pass ticks labels without specifying " *
                                            "ticks locations"))
        set_properties!(axis.ticks; defer_preview=true, opts...)
        return _preview()
    end
    # if locations exist but are different than the ones passed, remove the labels + rewrite locs
    if !isempty(axis.ticks.places) && axis.ticks.places != loc
        axis.ticks.labels = TicksLabels()
    end
    axis.ticks.places = loc
    # process labels if any are passed
    if !isempty(lab)
        length(lab) == length(loc) || throw(ArgumentError("Ticks locations and labels must " *
                                                          "have the same length."))
        axis.ticks.labels = TicksLabels(names=lab)
    end
    # set remaining properties and return
    set_properties!(axis.ticks; defer_preview=true, opts...)
    return _preview()
end

# Generate xticks!, xticks, and associated for each axis
for axs ∈ ("x", "y", "x2", "y2")
    f! = Symbol(axs * "ticks!")
    f  = Symbol(axs * "ticks")
    a  = Symbol(axs * "axis")
    ex = quote
        # xticks!([1, 2], ["a", "b"]; o...)
        $f!(loc::AVR, lab=String[]; o...) = _ticks!(Symbol($axs * "axis"), fl(loc), lab; o...)
        # xticks!("off"; o...)
        function $f!(s::String=""; o...)
            isempty(s) && return _ticks!(Symbol($axs * "axis"); o...)
            ax = getfield(gca(), Symbol($axs * "axis"))
            s_lc = lowercase(s)
            if s_lc == "off"
                reset!(ax.ticks)
                ax.ticks.off = true
                ax.ticks.labels.off = true
            elseif s_lc == "on"
                ax.ticks.off = false
                ax.ticks.labels.off = false
                set_properties!(ax.ticks; defer_preview=true, o...)
            else
                throw(ArgumentError("Unrecognised shorthand: $s"))
            end
            return _preview()
        end
        # overwrite
        $f(a...; o...) = $f!(a...; overwrite=true, o...)
    end
    eval(ex)
end

####
#### legend!, legend
####

"""
    $SIGNATURES

Update the properties of an existing legend object present on `axes`. If none
exist then a new one is created with the given properties.
"""
function legend!(vd::Option{Vector{DrawingHandle{T}}}=nothing, labels::Vector{String}=String[];
                 axes=nothing, overwrite=false, opts...) where T
    axes=check_axes(axes)
    # if there exists a legend object but overwrite, then reset it
    (!isdef(axes.legend) || overwrite) && (axes.legend = Legend())
    if isnothing(vd)
        isempty(labels) || throw(ArgumentError("Cannot pass labels without handles."))
        axes.legend.handles = [DrawingHandle(d) for d ∈ axes.drawings]
        axes.legend.labels = fill("", length(axes.drawings))
        s_ctr = 1
        f_ctr = 1
        h_ctr = 1
        b_ctr = 1
        for k ∈ 1:length(axes.drawings)
            if axes.drawings[k] isa Scatter2D
                axes.legend.labels[k] = "\"plot $s_ctr\""
                s_ctr += 1
            elseif axes.drawings[k] isa Fill2D
                axes.legend.labels[k] = "\"fill $f_ctr\""
                f_ctr += 1
            elseif axes.drawings[k] isa Hist2D
                axes.legend.labels[k] = "\"hist $h_ctr\""
                h_ctr += 1
            elseif axes.drawings[k] isa Bar2D
                axes.legend.labels[k] = "\"bar $b_ctr\""
                b_ctr += 1
            end
        end
    else
        length(vd) == length(labels) || throw(ArgumentError("There must be as many labels given "*
                                                            "as drawing handles"))
        axes.legend.handles = vd
        axes.legend.labels  = labels
    end
    set_properties!(axes.legend; defer_preview=true, opts...)
    return _preview()
end

"""
    legend(; options...)

Creates a new legend object on the current axes with the given options.
If one already exist, it will be destroyed and replaced by this one.
"""
legend(a...; o...) = legend!(a...; overwrite=true, o...)
