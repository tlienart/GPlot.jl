# NOTE: the type of the backend needs to be sent forward only in cases where
# the value the property can take are limited by the backend. For instance
# the name of the font will be limited by the backend.
# In most cases though, it is not the case and therefore a generic
# ::Type{Backend} (TBK) is all that is needed. See `set_prop/set_*.jl`.

"""
    set_properties(dict, obj; opts...)

Set properties of an object `obj` given options (`opts`) of the form
`optname=value` an applying it through appropriate application function
stored in the dictionary `dict`.
"""
function set_properties!(dict, obj; opts...)
    for optname ∈ opts.itr
        setprop! = get(dict, optname) do
            throw(UnknownOptionError(optname, obj))
        end
        setprop!(obj, opts[optname])
    end
    return obj
end

####
#### Options for STYLE
####

const TEXTSTYLE_OPTS = Dict{Symbol, Function}(
    :font     => set_font!,  # set_style
    :fontsize => set_hei!,   # .
    :col      => set_color!, # .
    :color    => set_color!  # .
    )

const LINESTYLE_OPTS = Dict{Symbol, Function}(
    :ls        => set_lstyle!, # set_style
    :lstyle    => set_lstyle!, # .
    :linestyle => set_lstyle!, # .
    :lw        => set_lwidth!, # .
    :lwidth    => set_lwidth!, # .
    :linewidth => set_lwidth!, # .
    :smooth    => set_smooth!, # .
    :col       => set_color!,  # .
    :color     => set_color!,  # .
    )

const MARKERSTYLE_OPTS = Dict{Symbol, Function}(
    :marker          => set_marker!, # set_style
    :msize           => set_msize!,  # .
    :markersize      => set_msize!,  # .
    :mcol            => set_mcol!,   # .
    :markercol       => set_mcol!,   # .
    :markercolor     => set_mcol!,   # .
    :mfacecol        => set_mcol!,   # .
    :mfacecolor      => set_mcol!,   # .
    :markerfacecolor => set_mcol!,   # .
    :mecol           => set_mecol!,  # .
    :medgecolor      => set_mecol!,  # .
    :markeredgecol   => set_mecol!,  # .
    :markeredgecolor => set_mecol!   # .
    )

const BARSTYLE_OPTS = Dict{Symbol, Function}(
    :col       => set_color!, # set_style
    :color     => set_color!, # .
    :ecol      => set_color!, # .
    :edgecol   => set_color!, # .
    :edgecolor => set_color!, # .
    :fcol      => set_fill!,  # .
    :fcolor    => set_fill!,  # .
    :facecolor => set_fill!,  # .
    :fill      => set_fill!,  # .
    )

const GBARSTYLE_OPTS = Dict{Symbol, Function}(
    :col        => set_colors!, # set_style
    :color      => set_colors!, # .
    :ecol       => set_colors!, # .
    :edgecol    => set_colors!, # .
    :edgecolor  => set_colors!, # .
    :cols       => set_colors!, # .
    :colors     => set_colors!, # .
    :ecols      => set_colors!, # .
    :edgecols   => set_colors!, # .
    :edgecolors => set_colors!, # .
    :fcol       => set_fills!,  # .
    :fcolor     => set_fills!,  # .
    :facecolor  => set_fills!,  # .
    :fill       => set_fills!,  # .
    :fcols      => set_fills!,  # .
    :fcolors    => set_fills!,  # .
    :facecolors => set_fills!,  # .
    :fills      => set_fills!,  # .
    )

const FILLSTYLE_OPTS = Dict{Symbol, Function}(
    :col       => set_color!, # set_style
    :color     => set_color!, # .
    :fcolor    => set_color!, # .
    :facecol   => set_color!, # .
    :facecolor => set_color!, # .
    :alpha     => set_alpha!, # .
    )

####
#### Options for AX_ELEMS
####

const TITLE_OPTS = Dict{Symbol, Function}(
    :text   => set_text!,   # set_ax_elems
    :dist   => set_dist!
    )
merge!(TITLE_OPTS, TEXTSTYLE_OPTS)
set_properties!(t::Title; opts...) = set_properties!(TITLE_OPTS, t; opts...)

const LEGEND_OPTS = Dict{Symbol, Function}(
    :pos      => set_position!, # set_drawing
    :position => set_position!, # .
    :fontsize => set_hei!,
    )
#XXX merge!(LEGEND_OPTS, TEXTSTYLE_OPTS)
set_properties!(l::Legend; opts...) = set_properties!(LEGEND_OPTS, l; opts...)

const TICKS_OPTS = Dict{Symbol, Function}(
    # ticks related
    :off        => set_off!,        # set_ax_elems
    :hideticks  => set_off!,        # .
    :len        => set_length!,     # .
    :length     => set_length!,     # .
    :sym        => set_symticks!,   # .
    :symticks   => set_symticks!,   # .
    :tickscol   => set_tickscolor!, # .
    :tickscolor => set_tickscolor!, #
    # labels related
    :hidelabels => set_labels_off!, # set_ax_elems
    :angle      => set_angle!,      # .
    :format     => set_format!,     # .
    :shift      => set_shift!,      # .
    :dist       => set_dist!,       # .
    )
merge!(TICKS_OPTS, LINESTYLE_OPTS) # ticks line
merge!(TICKS_OPTS, TEXTSTYLE_OPTS) # labels
set_properties!(t::Ticks; opts...) = set_properties!(TICKS_OPTS, t; opts...)

####
#### Options for DRAWINGS
####

const LINE2D_OPTS = Dict{Symbol, Function}(
    :name   => set_label!, # set_drawing
    :key    => set_label!, # .
    :label  => set_label!, # .
    :labels => set_label!, # .
    )
merge!(LINE2D_OPTS, LINESTYLE_OPTS)
merge!(LINE2D_OPTS, MARKERSTYLE_OPTS)
set_properties!(l::Line2D; opts...) = set_properties!(LINE2D_OPTS, l; opts...)

const FILL2D_OPTS = Dict{Symbol, Function}(
    :from => set_xmin!,
    :min  => set_xmin!,
    :xmin => set_xmin!,
    :to   => set_xmax!,
    :max  => set_xmax!,
    :xmax => set_xmax!,
    )
merge!(FILL2D_OPTS, FILLSTYLE_OPTS)
set_properties!(f::Fill2D; opts...) = set_properties!(FILL2D_OPTS, f; opts...)

const HIST2D_OPTS = Dict{Symbol, Function}(
    :bins       => set_bins!,    # set_drawing
    :nbins      => set_bins!,    # .
    :scaling    => set_scaling!, # .
    :norm       => set_scaling!, # .
    :horiz      => set_horiz!,   # .
    :horizontal => set_horiz!,   # .
    )
merge!(HIST2D_OPTS, BARSTYLE_OPTS)
set_properties!(h::Hist2D; opts...) = set_properties!(HIST2D_OPTS, h; opts...)

const GROUPEDBAR2D_OPTS = Dict{Symbol, Function}(
    :stacked    => set_stacked!, # set_drawing
    :horiz      => set_horiz!,   # .
    :horizontal => set_horiz!,   # .
    )
merge!(GROUPEDBAR2D_OPTS, GBARSTYLE_OPTS)
set_properties!(gb::GroupedBar2D; opts...) =
    set_properties!(GROUPEDBAR2D_OPTS, gb; opts...)

####
#### Options for FIGURE
####

const FIGURE_OPTS = Dict{Symbol, Function}(
    :size         => set_size!,         # set_figure
    :tex          => set_texlabels!,    # .
    :hastex       => set_texlabels!,    # .
    :latex        => set_texlabels!,    # .
    :haslatex     => set_texlabels!,    # .
    :texscale     => set_texscale!,     # .
    :alpha        => set_transparency!, # .
    :transparent  => set_transparency!, # .
    :transparency => set_transparency!, # .
    :preamble     => set_texpreamble!,  # .
    :texpreamble  => set_texpreamble!,  # .
    )
merge!(FIGURE_OPTS, TEXTSTYLE_OPTS)
set_properties!(f::Figure; opts...) = set_properties!(FIGURE_OPTS, f; opts...)
