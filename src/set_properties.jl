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
    :mfcol           => set_mfcol!,
    :mfacecol        => set_mfcol!,
    :mfacecolor      => set_mfcol!,
    :markerfacecolor => set_mfcol!,
    :mecol           => set_mecol!,
    :medgecol        => set_mecol!,
    :medgecolor      => set_mecol!,
    :markeredgecolor => set_mecol!,
    )

function set_properties!(b::Backend, line::Line2D; opts...)
    for optname ∈ opts.itr
        setprop! = get(LINE2D_OPTIONS, optname) do
            throw(UnknownOptionError(optname, line))
        end
        setprop!(b, line, opts[optname])
    end
    return line
end
