function title!(axes::Axes2D{B}, text::S, axsymb::Option{Symbol};
                overwrite=false, opts...) where {B<:Backend, S<:AbstractString}
    prefix, obj = "", axes
    if isdef(axsymb)
        axsymb == :x  && (prefix = "x" ; obj = axes.xaxis ;)
        axsymb == :x2 && (prefix = "x2"; obj = axes.x2axis;)
        axsymb == :y  && (prefix = "y" ; obj = axes.yaxis ;)
        axsymb == :y2 && (prefix = "y2"; obj = axes.y2axis;)
    end
    overwrite && (obj = Axis(prefix))
    setfield!(obj, :title, Title(text=text, prefix=prefix))
    set_properties!(B, getfield(obj, :title); opts...)
    return axes
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


title(axes::Axes2D{<:Backend}, text::AbstractString, axs::Option{Symbol}; opts...) = title!(axes, text, axs; overwrite=true, opts...)
title(::Nothing, text, axs; opts...) = title(add_axes2d!(), text, axs; opts...)

title(axes,   text; opts...) = title(axes, text, :x ; opts...)
xtitle(axes,  text; opts...) = title(axes, text, :x ; opts...)
x2title(axes, text; opts...) = title(axes, text, :x2; opts...)
ytitle(axes,  text; opts...) = title(axes, text, :y ; opts...)
y2title(axes, text; opts...) = title(axes, text, :y2; opts...)

title(text;   opts...) = title(gca(), text, ∅  ; opts...)
xtitle(text;  opts...) = title(gca(), text, :x ; opts...)
x2title(text; opts...) = title(gca(), text, :x2; opts...)
ytitle(text;  opts...) = title(gca(), text, :y ; opts...)
y2title(text; opts...) = title(gca(), text, :y2; opts...)
