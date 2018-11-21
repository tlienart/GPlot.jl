function set_properties!(::Type{B}, dict, obj; opts...) where B<:Backend
    for optname ∈ opts.itr
        setprop! = get(dict, optname) do
            throw(UnknownOptionError(optname, obj))
        end
        setprop!(B, obj, opts[optname])
    end
    return obj
end

const LINE2D_OPTIONS = Dict{Symbol, Function}(
    :ls              => set_lstyle!, # linestyle ...
    :lstyle          => set_lstyle!,
    :linestyle       => set_lstyle!,
    :lw              => set_lwidth!,
    :lwidth          => set_lwidth!,
    :linewidth       => set_lwidth!,
    :smooth          => set_smooth!,
    :col             => set_color!,
    :color           => set_color!,
    :marker          => set_marker!, # markerstyle ...
    :msize           => set_msize!,
    :markersize      => set_msize!,
    :mcol            => set_mcol!,
    :markercol       => set_mcol!,
    :markercolor     => set_mcol!,
    :mfacecol        => set_mcol!,
    :mfacecolor      => set_mcol!,
    :markerfacecolor => set_mcol!,
    )

set_properties!(::Type{B}, line::Line2D; opts...) where B =
    set_properties!(B, LINE2D_OPTIONS, line; opts...)

const TITLE_OPTIONS = Dict{Symbol, Function}(
    :font     => set_font!,
    :fontsize => set_hei!,
    :col      => set_color!,
    :color    => set_color!
    )

set_properties!(::Type{B}, title::Title; opts...) where B =
    set_properties!(B, TITLE_OPTIONS, title; opts...)
