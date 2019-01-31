# NOTE: the type of the backend needs to be sent forward only in cases where
# the value the property can take are limited by the backend. For instance
# the name of the font will be limited by the backend.
# In most cases though, it is not the case and therefore a generic
# ::Type{Backend} (TBK) is all that is needed. See `set_prop/set_*.jl`.

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

const LINESTYLE_OPTIONS = Dict{Symbol, Function}(
    :ls              => set_lstyle!, # linestyle ...
    :lstyle          => set_lstyle!,
    :linestyle       => set_lstyle!,
    :lw              => set_lwidth!,
    :lwidth          => set_lwidth!,
    :linewidth       => set_lwidth!,
    :smooth          => set_smooth!,
    :col             => set_color!,
    :color           => set_color!,
    )

const MARKERSTYLE_OPTIONS = Dict{Symbol, Function}(
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

const BARSTYLE_OPTIONS = Dict{Symbol, Function}(
    :col            => set_color!,   # edge color
    :color          => set_color!,
    :ecol           => set_color!,
    :edgecol        => set_color!,
    :edgecolor      => set_color!,
    :fcol           => set_fill!,    # face color
    :fcolor         => set_fill!,
    :facecolor      => set_fill!,
    :fill           => set_fill!,
    )

const GBARSTYLE_OPTIONS = Dict{Symbol, Function}(
    :col            => set_colors!, # edge colors (VECTOR)
    :color          => set_colors!,
    :ecol           => set_colors!,
    :edgecol        => set_colors!,
    :edgecolor      => set_colors!,
    :cols           => set_colors!, # edge colors (VECTOR)
    :colors         => set_colors!,
    :ecols          => set_colors!,
    :edgecols       => set_colors!,
    :edgecolors     => set_colors!,
    :fcol           => set_fills!,  # face colors (VECTOR)
    :fcolor         => set_fills!,
    :facecolor      => set_fills!,
    :fill           => set_fills!,
    :fcols          => set_fills!,  # face colors (VECTOR)
    :fcolors        => set_fills!,
    :facecolors     => set_fills!,
    :fills          => set_fills!,
    )

const FILLSTYLE_OPTIONS = Dict{Symbol, Function}(
    :col       => set_color!,
    :color     => set_color!,
    :fcolor    => set_color!,
    :facecol   => set_color!,
    :facecolor => set_color!,
    :alpha     => set_alpha!,
    )

####
#### Options for AX_ELEMS
####

const TITLE_OPTIONS = Dict{Symbol, Function}(
    :text   => set_text!,
    :prefix => set_prefix!,
    :dist   => set_dist!
    )
merge!(TITLE_OPTIONS, TEXTSTYLE_OPTIONS)
set_properties!(::Type{B}, title::Title; opts...) where B <: Backend =
    set_properties!(B, TITLE_OPTIONS, title; opts...)

const LEGEND_OPTIONS = Dict{Symbol, Function}(
    :pos      => set_position!,
    :position => set_position!,
    :fontsize => set_hei!,
    )
#XXX merge!(LEGEND_OPTIONS, TEXTSTYLE_OPTIONS)
set_properties!(fig::Type{B}, legend::Legend; opts...) where B <: Backend =
    set_properties!(B, LEGEND_OPTIONS, legend; opts...)

const TICKS_OPTIONS = Dict{Symbol, Function}(
    # ticks related
    :off        => set_off!,        # ticks.off
    :hideticks  => set_off!,
    :len        => set_length!,
    :length     => set_length!,     # ticks.length
    :sym        => set_symticks!,
    :symticks   => set_symticks!,   # ticks.symticks
    :tickscol   => set_tickscolor!,
    :tickscolor => set_tickscolor!,
    # labels related
    :hidelabels => set_labels_off!, # ticks.labels.off
    :angle      => set_angle!,      # ticks.labels.angle
    :format     => set_format!,     # ticks.labels.format
    :shift      => set_shift!,      # ticks.labels.shift
    :dist       => set_dist!,       # ticks.labels.dist
    )
merge!(TICKS_OPTIONS, LINESTYLE_OPTIONS) # ticks line
merge!(TICKS_OPTIONS, TEXTSTYLE_OPTIONS) # labels
set_properties!(::Type{B}, ticks::Ticks; opts...) where {B} =
    set_properties!(B, TICKS_OPTIONS, ticks; opts...)

####
#### Options for DRAWINGS
####

const LINE2D_OPTIONS = Dict{Symbol, Function}(
    :name            => set_label!, # label
    :key             => set_label!,
    :label           => set_label!,
    )
merge!(LINE2D_OPTIONS, LINESTYLE_OPTIONS)
merge!(LINE2D_OPTIONS, MARKERSTYLE_OPTIONS)
set_properties!(::Type{B}, line::Line2D; opts...) where {B} =
    set_properties!(B, LINE2D_OPTIONS, line; opts...)

const FILL2D_OPTIONS = Dict{Symbol, Function}(
    :from      => set_xmin!,
    :min       => set_xmin!,
    :xmin      => set_xmin!,
    :to        => set_xmax!,
    :max       => set_xmax!,
    :xmax      => set_xmax!,
    )
merge!(FILL2D_OPTIONS, FILLSTYLE_OPTIONS)
set_properties!(::Type{B}, fill::Fill2D; opts...) where {B} =
    set_properties!(B, FILL2D_OPTIONS, fill; opts...)


const HIST2D_OPTIONS = Dict{Symbol, Function}(
    :bins           => set_bins!,    # number of bins
    :nbins          => set_bins!,
    :scaling        => set_scaling!, # normalisation
    :norm           => set_scaling!,
    :horiz          => set_horiz!,   # show bar horizontal
    :horizontal     => set_horiz!,
    )
merge!(HIST2D_OPTIONS, BARSTYLE_OPTIONS)
set_properties!(::Type{B}, hist::Hist2D; opts...) where {B} =
    set_properties!(B, HIST2D_OPTIONS, hist; opts...)

const GROUPEDBAR2D_OPTIONS = Dict{Symbol, Function}(
    :stacked        => set_stacked!,
    :horiz          => set_horiz!,   # show bar horizontal
    :horizontal     => set_horiz!,
    )
merge!(GROUPEDBAR2D_OPTIONS, GBARSTYLE_OPTIONS)
set_properties!(::Type{B}, gb::GroupedBar2D; opts...) where {B} =
    set_properties!(B, GROUPEDBAR2D_OPTIONS, gb; opts...)

####
#### Options for FIGURE
####

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

set_properties!(fig::Figure{B}; opts...) where B <: Backend =
    set_properties!(B, FIGURE_OPTIONS, fig; opts...)
