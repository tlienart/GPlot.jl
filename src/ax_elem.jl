####
#### [x|y|x2|y2]title[!]
####

"""
    _title!(a, text, el)

Internal function to set the title of axes (`el==:title`) or axis objects (`el==:xtitle`...).
"""
function _title!(a::Axes2D, text::String, el::Symbol; overwrite=false, opts...)
    obj = (el == :axis) ? a : getfield(a, el)
    if isdef(obj.title)
        # if overwrite, clear the current title
        overwrite && clear!(obj.title)
        obj.title.text = text
    else # title doesn't exist, create one
        obj.title = Title(text=text)
    end
    set_properties!(obj.title; opts...)
    return a
end
_title!(::Nothing, a...; o...) = _title!(add_axes2d!(), a...; o...)

# Generate xlim!, xlim, and associated for each axis
for axs ∈ ["", "x", "y", "x2", "y2"]
    f!  = Symbol(axs * "title!")
    f   = Symbol(axs * "title")
    f2! = Symbol(axs * "label!") # synonyms xlabel = xtitle
    f2  = Symbol(axs * "label")
    ex = quote
        # mutate
        $f!(a, text; opts...) = _title!(a, text, Symbol($axs * "axis"); opts...)
        $f!(text; opts...)    = $f!(gca(), text; opts...)
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

function _ticks!(a::Axes2D, axs::Symbol, loc::Vector{Float64},
                 lab::Option{Vector{String}}; overwrite=false, opts...)
    axis = getfield(a, axs)
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
_ticks!(::Nothing, a...; o...) = _ticks!(add_axes2d!(), a...; o...)

# Generate xticks!, xticks, and associated for each axis
for axs ∈ ["", "x", "y", "x2", "y2"]
    f! = Symbol(axs * "ticks!")
    f  = Symbol(axs * "ticks")
    ex = quote
        $f!(a, loc::AVR, lab=∅; opts...) =
            _ticks!(a, Symbol($axs * "axis"), convert(Vector{Float64}, loc), lab; opts...)
        $f!(loc::AVR, lab=∅; opts...) = $f!(gca(), convert(Vector{Float64}, loc), lab; opts...)
        # overwrite
        $f(a, loc::AVR, lab=∅; opts...) = $f!(a, loc, lab; overwrite=true, opts...)
        $f(loc::AVR, lab=∅; opts...)    = $f!(gca(), loc, lab; overwrite=true, opts...)
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
function legend!(a::Axes2D; overwrite=false, opts...)
    isdef(a) || (a = add_axes2d!())
    # if there exists a legend object but overwrite, then reset it
    (!isdef(a.legend) || overwrite) && (a.legend = Legend())
    set_properties!(a.legend; opts...)
    return a
end
legend!(::Nothing; opts...) = legend!(add_axes2d!(); opts...)
legend!(; opts...) = legend!(gca(); opts...)

"""
    legend(; options...)

Creates a new legend object on the current axes with the given options.
If one already exist, it will be destroyed and replaced by this one.
"""
legend(; opts...) = legend!(gca(); overwrite=true, opts...)
