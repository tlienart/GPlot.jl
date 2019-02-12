####
#### [x|y|x2|y2]title[!]
####

function _title!(a::Option{Axes2D}, text::String, axsymb::Option{Symbol};
                         overwrite=false, opts...)
    isdef(a) || (a = add_axes2d!())
    prefix = ""
    obj = a
    if isdef(axsymb)
        prefix = "$axsymb"
        obj = getfield(a, Symbol(prefix * "axis"))
    end
    if isdef(obj.title)
        # if overwrite, clear the current title
        overwrite && clear!(obj.title)
        obj.title.text = text
    else
        obj.title = Title(text=text, prefix=prefix)
    end
    set_properties!(obj.title; opts...)
    return a
end

# Generate xlim!, xlim, and associated for each axis
for axs ∈ ["", "x", "y", "x2", "y2"]
    f!  = Symbol(axs * "title!")
    f   = Symbol(axs * "title")
    f2! = Symbol(axs * "label!") # synonyms xlabel = xtitle
    f2  = Symbol(axs * "label")
    ex = quote
        if isempty($axs)
            $f!(a, text; opts...) = _title!(a, text, ∅; opts...)
        else
            $f!(a, text; opts...) = _title!(a, text, Symbol($axs); opts...)
        end
        $f!(text; opts...)   = $f!(gca(), text; opts...)
        # overwrite
        $f(a, text; opts...) = $f!(a, text; overwrite=true, opts...)
        $f(text; opts...)    = $f!(gca(), text; overwrite=true, opts...)
        # more synonyms xlabel...
        !isempty($axs) && ($f2! = $f!; $f2 = $f)
    end
    eval(ex)
end

####
#### [x|y|x2|y2]ticks
####

function _ticks!(a::Option{Axes2D}, axsymb::Symbol, loc::AVR,
                         lab::Option{Vector{String}}; overwrite=false,
                         opts...)
    isdef(a) || (a = add_axes2d!())
    prefix = "$axsymb"
    axis = getfield(a, Symbol(prefix * "axis"))
    locf = convert(Vector{Float64}, loc)
    # if overwrite, clear the current ticks object
    overwrite && clear!(axis.ticks)
    # if locations have changed, remove the labels, rewrite locs
    if isdef(axis.ticks.places) && axis.ticks.places != locf
        clear!(axis.ticks.labels)
    end
    axis.ticks.places = locf
    if isdef(lab)
        @assert length(lab) == length(loc) "Ticks location and ticks labels " *
                                           "must have the same length."
        axis.ticks.labels = TicksLabels(names=lab)
    end
    set_properties!(axis.ticks; opts...)
    return a
end

# Generate xticks!, xticks, and associated for each axis
for axs ∈ ["", "x", "y", "x2", "y2"]
    f!  = Symbol(axs * "ticks!")
    f   = Symbol(axs * "ticks")
    ex = quote
        $f!(a, loc, lab=∅; opts...)   = _ticks!(a, Symbol($axs), loc, lab; opts...)
        $f!(loc::AVR, lab=∅; opts...) = $f!(gca(), loc, lab; opts...)
        # overwrite
        $f(a, loc, lab=∅; opts...)   = $f!(a, loc, lab; overwrite=true, opts...)
        $f(loc::AVR, lab=∅; opts...) = $f!(gca(), loc, lab; overwrite=true, opts...)
    end
    eval(ex)
end

####
#### legend!, legend
####

"""
    legend!(axes; options...)

Update the properties of an existing legend object present on `axes`. If none
exist then a new one is created with the given properties.
"""
function legend!(a::Option{Axes2D}; overwrite=false, opts...)
    isdef(a) || (a = add_axes2d!())
    # if there exists a legend object but overwrite, then reset it
    (!isdef(a.legend) || overwrite) && (a.legend = Legend())
    set_properties!(a.legend; opts...)
    return a
end

legend!(; opts...) = legend!(gca(); opts...)

"""
    legend(; options...)

Creates a new legend object on the current axes with the given options.
If one already exist, it will be destroyed and replaced by this one.
"""
legend(; opts...) = legend!(gca(); overwrite=true, opts...)
