####
#### [x|y|x2|y2]title[!]
####

function title!(axes::Axes2D{B}, text::AbstractString, axsymb::Option{Symbol};
                overwrite=false, opts...) where B <: Backend

    prefix, obj = "", axes
    if isdef(axsymb)
        axsymb == :x  && (prefix = "x" ; obj = axes.xaxis ;)
        axsymb == :x2 && (prefix = "x2"; obj = axes.x2axis;)
        axsymb == :y  && (prefix = "y" ; obj = axes.yaxis ;)
        axsymb == :y2 && (prefix = "y2"; obj = axes.y2axis;)
        overwrite && clear!(obj)
    end
    setfield!(obj, :title, Title(text=text, prefix=prefix))
    set_properties!(B, getfield(obj, :title); opts...)
    return
end

title!(::Nothing, text, axs; opts) = title!(add_axes2d!(), text, axs; opts...)

title!(axes,   text; opts...) = title!(axes, text, ∅  ; opts...)
xtitle!(axes,  text; opts...) = title!(axes, text, :x ; opts...)
x2title!(axes, text; opts...) = title!(axes, text, :x2; opts...)
ytitle!(axes,  text; opts...) = title!(axes, text, :y ; opts...)
y2title!(axes, text; opts...) = title!(axes, text, :y2; opts...)

title!(text;   opts...) = title!(gca(), text, ∅  ; opts...)
xtitle!(text;  opts...) = title!(gca(), text, :x ; opts...)
x2title!(text; opts...) = title!(gca(), text, :x2; opts...)
ytitle!(text;  opts...) = title!(gca(), text, :y ; opts...)
y2title!(text; opts...) = title!(gca(), text, :y2; opts...)

###

title(axes, text, axs; opts...) = title!(axes, text, axs; overwrite=true, opts...)
title(::Nothing, text, axs; opts...) = title(add_axes2d!(), text, axs; opts...)

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
#### [x|y]lim, [x|y]lim! (synonyms though with ! is preferred)
####

xlim!(a::Axes2D{B}, min, max) where B<:Backend = set_lims!(B, a.xaxis, min,max)
xlim!(min, max) = xlim!(gca(), min, max)
xlim!(;min=nothing, max=nothing) = xlim!(gca(), min, max)

# SYNONYMS
xlim(a::Axes2D{B}, min, max) where B<:Backend = set_lims!(B, a.xaxis, min, max)
xlim(min, max) = xlim!(gca(), min, max)
xlim(;min=nothing, max=nothing) = xlim!(gca(), min, max)

ylim!(a::Axes2D{B}, min, max) where B<:Backend = set_lims!(B, a.yaxis, min,max)
ylim!(min, max) = ylim!(gca(), min, max)
ylim!(;min=nothing, max=nothing) = ylim!(gca(), min, max)

# SYNONYMS
ylim(a::Axes2D{B}, min, max) where B<:Backend = set_lims!(B, a.yaxis, min, max)
ylim(min, max) = ylim!(gca(), min, max)
ylim(;min=nothing, max=nothing) = ylim!(gca(), min, max)

####
#### [x|y]lim, [x|y]lim! (synonyms though with ! is preferred)
####

xscale!(a::Axes2D{B}, v::String) where B<:Backend = set_scale!(B, a.xaxis, v)
xscale!(v) = xscale!(gca(), v)

# SYNONYMS
xscale(a::Axes2D{B}, v::String) where B<:Backend = set_scale!(B, a.xaxis, v)
xscale(v) = xscale!(gca(), v)

yscale!(a::Axes2D{B}, v::String) where B<:Backend = set_scale!(B, a.yaxis, v)
yscale!(v) = yscale!(gca(), v)

# SYNONYMS
yscale(a::Axes2D{B}, v::String) where B<:Backend = set_scale!(B, a.yaxis, v)
yscale(v) = yscale!(gca(), v)
