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
        @show obj.title
        @show typeof(obj.title)
        @show fieldnames(typeof(obj.title))
        overwrite && clear!(obj.title)
        obj.title.text = text
    else
        obj.title = Title(text=text, prefix=prefix)
    end
    set_properties!(obj.title; opts...)
    return a
end

title!(a,   text; opts...) = _title!(a, text, ∅  ; opts...)
xtitle!(a,  text; opts...) = _title!(a, text, :x ; opts...)
x2title!(a, text; opts...) = _title!(a, text, :x2; opts...)
ytitle!(a,  text; opts...) = _title!(a, text, :y ; opts...)
y2title!(a, text; opts...) = _title!(a, text, :y2; opts...)

title!(text;   opts...) = title!(gca(),   text; opts...)
xtitle!(text;  opts...) = xtitle!(gca(),  text; opts...)
x2title!(text; opts...) = x2title!(gca(), text; opts...)
ytitle!(text;  opts...) = ytitle!(gca(),  text; opts...)
y2title!(text; opts...) = y2title!(gca(), text; opts...)

title(a,   text; opts...) = title!(a,   text; overwrite=true, opts...)
xtitle(a,  text; opts...) = xtitle!(a,  text; overwrite=true, opts...)
x2title(a, text; opts...) = x2title!(a, text; overwrite=true, opts...)
ytitle(a,  text; opts...) = ytitle!(a,  text; overwrite=true, opts...)
y2title(a, text; opts...) = y2title!(a, text; overwrite=true, opts...)

title(text;   opts...) = title(gca(),   text; opts...)
xtitle(text;  opts...) = xtitle(gca(),  text; opts...)
x2title(text; opts...) = x2title(gca(), text; opts...)
ytitle(text;  opts...) = ytitle(gca(),  text; opts...)
y2title(text; opts...) = y2title(gca(), text; opts...)

# Synonyms
xlabel = xtitle
ylabel = ytitle
x2label = x2title
y2label = y2title
xlabel! = xtitle!
ylabel! = ytitle!
x2label! = x2title!
y2label! = y2title!

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
    if isdef(axis.ticks.places) && !(axis.ticks.places == locf)
        # locations have changed, so overwrite the labels
        clear!(axis.ticks.labels)
    end
    axis.ticks = Ticks(prefix=prefix, places=locf)
    if isdef(lab)
        @assert length(lab) == length(loc) "Ticks location and " *
                                           "ticks labels must have " *
                                           "the same length."
        axis.ticks.labels = TicksLabels(names=lab)
    end
    set_properties!(axis.ticks; opts...)
    return a
end

xticks!(a,  loc, lab=∅; opts...) = _ticks!(a, :x,  loc, lab; opts...)
x2ticks!(a, loc, lab=∅; opts...) = _ticks!(a, :x2, loc, lab; opts...)
yticks!(a,  loc, lab=∅; opts...) = _ticks!(a, :y,  loc, lab; opts...)
y2ticks!(a, loc, lab=∅; opts...) = _ticks!(a, :y2, loc, lab; opts...)

xticks!(loc::Vector,  lab=∅; opts...) = xticks!(gca(),  loc, lab; opts...)
x2ticks!(loc::Vector, lab=∅; opts...) = x2ticks!(gca(), loc, lab; opts...)
yticks!(loc::Vector,  lab=∅; opts...) = yticks!(gca(),  loc, lab; opts...)
y2ticks!(loc::Vector, lab=∅; opts...) = y2ticks!(gca(), loc, lab; opts...)

xticks(a,  loc, lab=∅; opts...) = xticks!(a,  loc, lab; overwrite=true, opts...)
x2ticks(a, loc, lab=∅; opts...) = x2ticks!(a, loc, lab; overwrite=true, opts...)
yticks(a,  loc, lab=∅; opts...) = yticks!(a,  loc, lab; overwrite=true, opts...)
y2ticks(a, loc, lab=∅; opts...) = y2ticks!(a, loc, lab; overwrite=true, opts...)

xticks(loc::Vector,  lab=∅; opts...) = xticks(gca(),  loc, lab; opts...)
x2ticks(loc::Vector, lab=∅; opts...) = x2ticks(gca(), loc, lab; opts...)
yticks(loc::Vector,  lab=∅; opts...) = yticks(gca(),  loc, lab; opts...)
y2ticks(loc::Vector, lab=∅; opts...) = y2ticks(gca(), loc, lab; opts...)

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
