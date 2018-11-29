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
    :name            => set_label!, # label
    :key             => set_label!,
    :label           => set_label!,
    )

const TEXT_OPTIONS = Dict{Symbol, Function}(
    :font     => set_font!,
    :fontsize => set_hei!,
    :col      => set_color!,
    :color    => set_color!
    )

const TITLE_OPTIONS = Dict{Symbol, Function}(
    :dist => set_dist!
    )
merge!(TITLE_OPTIONS, TEXT_OPTIONS)

const FIG_OPTIONS = Dict{Symbol, Function}(
    :size         => set_size!,        # doc
    :tex          => set_texlabels!,   # doc
    :hastex       => set_texlabels!,   # doc
    :latex        => set_texlabels!,   # doc
    :haslatex     => set_texlabels!,   # doc
    :texscale     => set_texscale!,    # doc
    :alpha        => set_transparency!,#
    :transparent  => set_transparency!,
    :transparency => set_transparency!,
    :preamble     => set_texpreamble!,
    :texpreamble  => set_texpreamble!,
    )
merge!(FIG_OPTIONS, TEXT_OPTIONS)

const LEGEND_OPTIONS = Dict{Symbol, Function}(
    :pos      => set_position!,
    :position => set_position!,
    :fontsize => set_hei!,
    )

set_properties!(::Type{B}, line::Line2D; opts...) where B =
    set_properties!(B, LINE2D_OPTIONS, line; opts...)

set_properties!(::Type{B}, title::Title; opts...) where B =
    set_properties!(B, TITLE_OPTIONS, title; opts...)

set_properties!(fig::Figure{B}; opts...) where B =
    set_properties!(B, FIG_OPTIONS, fig; opts...)

set_properties!(fig::Type{B}, legend::Legend; opts...) where B =
    set_properties!(B, LEGEND_OPTIONS, legend; opts...)
