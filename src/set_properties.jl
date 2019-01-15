"""
    set_properties(::B, dict, obj; opts...)

Set properties of an object `obj` given options (`opts`) of the form
`optname=value` an applying it through appropriate application function
stored in the dictionary `dict`.
"""
function set_properties!(::Type{B}, dict, obj; opts...) where B <: Backend
    for optname ∈ opts.itr
        setprop! = get(dict, optname) do
            throw(UnknownOptionError(optname, obj))
        end
        setprop!(B, obj, opts[optname])
    end
    return obj
end

####
#### Options for STYLE
####

const TEXTSTYLE_OPTIONS = Dict{Symbol, Function}(
    :font     => set_font!,
    :fontsize => set_hei!,
    :col      => set_color!,
    :color    => set_color!
    )

####
#### Options for DRAWINGS
####

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

set_properties!(::Type{<:Backend}, line::Line2D; opts...) =
    set_properties!(B, LINE2D_OPTIONS, line; opts...)

####
#### Options for FIGURE
####

const TITLE_OPTIONS = Dict{Symbol, Function}(
    :text   => set_text!,
    :prefix => set_prefix!,
    #XXX :textstyle => set_textstyle!,
    :dist   => set_dist!
    )
merge!(TITLE_OPTIONS, TEXTSTYLE_OPTIONS)

const LEGEND_OPTIONS = Dict{Symbol, Function}(
    :pos      => set_position!,
    :position => set_position!,
    :fontsize => set_hei!,
    )

const FIGURE_OPTIONS = Dict{Symbol, Function}(
    :size         => set_size!,
    :tex          => set_texlabels!,
    :hastex       => set_texlabels!,
    :latex        => set_texlabels!,
    :haslatex     => set_texlabels!,
    :texscale     => set_texscale!,
    :alpha        => set_transparency!,
    :transparent  => set_transparency!,
    :transparency => set_transparency!,
    :preamble     => set_texpreamble!,
    :texpreamble  => set_texpreamble!,
    )
merge!(FIGURE_OPTIONS, TEXTSTYLE_OPTIONS)

set_properties!(::Type{B}, title::Title; opts...) where B <: Backend =
    set_properties!(B, TITLE_OPTIONS, title; opts...)

set_properties!(fig::Type{B}, legend::Legend; opts...) where B <: Backend =
    set_properties!(B, LEGEND_OPTIONS, legend; opts...)

set_properties!(fig::Figure{B}; opts...) where B <: Backend =
    set_properties!(B, FIGURE_OPTIONS, fig; opts...)
