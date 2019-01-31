####
#### [x|y|x2|y2]title[!]
####

function _title!(a::Axes2D, text::String, axsymb::Option{Symbol};
                overwrite=false, opts...)
    prefix, obj = "", a
    if isdef(axsymb)
        prefix = "$axsymb"
        obj = getfield(a, Symbol(prefix * "axis"))
    end
    # if overwrite, clear the current title
    overwrite && clear!(obj.title)
    obj.title = Title(text=text, prefix=prefix)
    return a
end

title!(::Nothing, text, axs; opts...) = _title!(add_axes2d!(), text, axs; opts...)

title!(axes,   text; opts...) = _title!(axes, text, ∅  ; opts...)
xtitle!(axes,  text; opts...) = _title!(axes, text, :x ; opts...)
x2title!(axes, text; opts...) = _title!(axes, text, :x2; opts...)
ytitle!(axes,  text; opts...) = _title!(axes, text, :y ; opts...)
y2title!(axes, text; opts...) = _title!(axes, text, :y2; opts...)

title!(text;   opts...) = _title!(gca(), text, ∅  ; opts...)
xtitle!(text;  opts...) = _title!(gca(), text, :x ; opts...)
x2title!(text; opts...) = _title!(gca(), text, :x2; opts...)
ytitle!(text;  opts...) = _title!(gca(), text, :y ; opts...)
y2title!(text; opts...) = _title!(gca(), text, :y2; opts...)

# ---

title(axes, text, axs; opts...) = _title!(axes, text, axs; overwrite=true, opts...)
title(::Nothing, text, axs; opts...) = _title!(add_axes2d!(), text, axs; opts...)

title(axes,   text; opts...) = title(axes, text, ∅  ; opts...)
xtitle(axes,  text; opts...) = title(axes, text, :x ; opts...)
x2title(axes, text; opts...) = title(axes, text, :x2; opts...)
ytitle(axes,  text; opts...) = title(axes, text, :y ; opts...)
y2title(axes, text; opts...) = title(axes, text, :y2; opts...)

title(text;   opts...) = title(gca(), text, ∅  ; opts...)
xtitle(text;  opts...) = title(gca(), text, :x ; opts...)
x2title(text; opts...) = title(gca(), text, :x2; opts...)
ytitle(text;  opts...) = title(gca(), text, :y ; opts...)
y2title(text; opts...) = title(gca(), text, :y2; opts...)

####
#### [x|y|x2|y2]ticks
####

function _ticks!(a::Axes2D, axsymb::Symbol, loc::Vector{<:Real},
                 lab::Option{Vector{String}}; overwrite=false,
                 opts...)
    prefix = "$axsymb"
    axis = getfield(a, Symbol(prefix * "axis"))
    # if overwrite, clear the current ticks object
    overwrite && clear!(axis.ticks)
    axis.ticks = Ticks(prefix=prefix, places=loc)
    if isdef(lab)
        @assert length(lab) == length(loc) "Ticks location and " *
                                           "ticks labels must have " *
                                           "the same length."
        axis.ticks.labels = TicksLabels(names=lab)
    end
    set_properties!(axis.ticks; opts...)
    return a
end

xticks!(::Nothing, loc, lab; opts...) = _ticks!(add_axes2d!(), :x, loc, lab; opts...)
x2ticks!(::Nothing, loc, lab; opts...) = _ticks!(add_axes2d!(), :x2, loc, lab; opts...)
yticks!(::Nothing, loc, lab; opts...) = _ticks!(add_axes2d!(), :y, loc, lab; opts...)
y2ticks!(::Nothing, loc, lab; opts...) = _ticks!(add_axes2d!(), :y2, loc, lab; opts...)

xticks!(axes::Axes2D, loc, lab=∅; opts...) = _ticks!(axes, :x, loc, lab; opts...)
x2ticks!(axes::Axes2D, loc, lab=∅; opts...) = _ticks!(axes, :x2, loc, lab; opts...)
yticks!(axes::Axes2D, loc, lab=∅; opts...) = _ticks!(axes, :y, loc, lab; opts...)
y2ticks!(axes::Axes2D, loc, lab=∅; opts...) = _ticks!(axes, :y2, loc, lab; opts...)

xticks!(loc::Vector, lab=∅; opts...) = _ticks!(gca(), :x, loc, lab; opts...)
x2ticks!(loc::Vector, lab=∅; opts...) = _ticks!(gca(), :x2, loc, lab; opts...)
yticks!(loc::Vector, lab=∅; opts...) = _ticks!(gca(), :y, loc, lab; opts...)
y2ticks!(loc::Vector, lab=∅; opts...) = _ticks!(gca(), :y2, loc, lab; opts...)

xticks(axes::Axes2D, loc, lab=∅; opts...) = _ticks!(axes, :x, loc, lab; overwrite=true, opts...)
x2ticks(axes::Axes2D, loc, lab=∅; opts...) = _ticks!(axes, :x2, loc, lab; overwrite=true, opts...)
yticks(axes::Axes2D, loc, lab=∅; opts...) = _ticks!(axes, :y, loc, lab; overwrite=true, opts...)
y2ticks(axes::Axes2D, loc, lab=∅; opts...) = _ticks!(axes, :y2, loc, lab; overwrite=true, opts...)

xticks(loc::Vector, lab=∅; opts...) = _ticks!(gca(), :x, loc, lab; overwrite=true, opts...)
x2ticks(loc::Vector, lab=∅; opts...) = _ticks!(gca(), :x2, loc, lab; overwrite=true, opts...)
yticks(loc::Vector, lab=∅; opts...) = _ticks!(gca(), :y, loc, lab; overwrite=true, opts...)
y2ticks(loc::Vector, lab=∅; opts...) = _ticks!(gca(), :y2, loc, lab; overwrite=true, opts...)

####
#### legend!, legend
####

"""
    legend!(axes; options...)

Update the properties of an existing legend object present on `axes`. If none
exist then a new one is created with the given properties.
"""
function legend!(a::Axes2D; overwrite=false, opts...)
    # if there exists a legend object but overwrite, then reset it
    (!isdef(a.legend) || overwrite) && (a.legend = Legend())
    set_properties!(a.legend; opts...)
    return a
end

"""
    legend(; options...)

Creates a new legend object on the current axes with the given options.
If one already exist, it will be destroyed and replaced by this one.
"""
@inline legend(; opts...) = legend!(gca(); overwrite=true, opts...)
