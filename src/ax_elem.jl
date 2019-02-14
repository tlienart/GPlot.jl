####
#### [x|y|x2|y2]title[!]
####

"""
    _title!(a, text, el)

Internal function to set the title of axes (`el==:title`) or axis objects (`el==:xtitle`...).
"""
function _title!(a::Axes2D, text::String, el::Symbol;
                 overwrite=false, opts...)
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
for axs ∈ ("", "x", "y", "x2", "y2")
    f!  = Symbol(axs * "title!")
    f   = Symbol(axs * "title")
    f2! = Symbol(axs * "label!") # synonyms xlabel = xtitle
    f2  = Symbol(axs * "label")
    ex = quote
        # mutate
        $f!(a::Axes2D, t::String; o...) = _title!(a, t, Symbol($axs * "axis"); o...)
        $f!(t::String; o...) = _title!(gca(), t, Symbol($axs * "axis"); o...)
        # overwrite
        $f(a...; o...) = $f!(a...; overwrite=true, o...)
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
    # if overwrite, clear the current ticks object
    overwrite && clear!(axis.ticks)
    # if locations have changed, remove the labels, rewrite locs
    if isdef(axis.ticks.places) && axis.ticks.places != loc
        clear!(axis.ticks.labels)
    end
    axis.ticks.places = loc
    # check if axis limits are ok with the locations and adjust
    # as necessary
    minloc, maxloc = minimum(loc), maximum(loc)
    if isnothing(axis.min) || axis.min > minloc
        axis.min = minloc - 0.1abs(minloc)
    end
    if isnothing(axis.max) || axis.max < maxloc
        axis.max = maxloc + 0.1abs(maxloc)
    end
    # check if the labels match
    if isdef(lab)
        if length(lab) != length(loc)
            throw(OptionValueError("Ticks locations and labels must have the same length.", lab))
        end
        axis.ticks.labels = TicksLabels(names=lab)
    end
    set_properties!(axis.ticks; opts...)
    return a
end
_ticks!(::Nothing, a...; o...) = _ticks!(add_axes2d!(), a...; o...)

# Generate xticks!, xticks, and associated for each axis
for axs ∈ ("x", "y", "x2", "y2")
    f! = Symbol(axs * "ticks!")
    f  = Symbol(axs * "ticks")
    a  = Symbol(axs * "axis")
    ex = quote
        $f!(a::Axes2D, loc::Union{ARR,AVR}, lab::Option{Vector{String}}=∅; o...) =
            _ticks!(a, Symbol($axs * "axis"), fl(loc), lab; opts...)
        $f!(loc::Union{ARR,AVR}, lab::Option{Vector{String}}=∅; opts...) =
            _ticks!(gca(), Symbol($axs * "axis"), fl(loc), lab; opts...)
        function $f!(s::String; o...)
            s_lc = lowercase(s)
            if s_lc == "off"
                ax = getfield(gca(), Symbol($axs * "axis"))
                reset!(ax.ticks)
                @show ax.ticks.labels.names
                ax.ticks.off = true
                ax.ticks.labels.off = true
            else
                throw(OptionValueError("Unrecognised shorthand for $f:", s))
            end
            return gca()
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
