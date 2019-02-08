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

const GLINESTYLE_OPTS = Dict{Symbol, Function}(
    :ls         => set_lstyle_v!, # set_style
    :lstyle     => set_lstyle_v!, # .
    :linestyle  => set_lstyle_v!, # .
    :lstyles    => set_lstyle_v!, # .
    :linestyles => set_lstyle_v!, # .
    :lw         => set_lwidth_v!, # .
    :lwidth     => set_lwidth_v!, # .
    :linewidth  => set_lwidth_v!, # .
    :lwidths    => set_lwidth_v!, # .
    :linewidths => set_lwidth_v!, # .
    :smooth     => set_smooth_v!, # .
    :smooths    => set_smooth_v!, # .
    :col        => set_color_v!,  # .
    :color      => set_color_v!,  # .
    :cols       => set_color_v!,  # .
    :colors     => set_color_v!,  # .
    )

const GMARKERSTYLE_OPTS = Dict{Symbol, Function}(
    :marker           => set_marker_v!, # set_style
    :markers          => set_marker_v!, # .
    :msize            => set_msize_v!,  # .
    :msizes           => set_msize_v!,  # .
    :markersize       => set_msize_v!,  # .
    :markersizes      => set_msize_v!,  # .
    :mcol             => set_mcol_v!,   # .
    :markercol        => set_mcol_v!,   # .
    :markercolor      => set_mcol_v!,   # .
    :mfacecol         => set_mcol_v!,   # .
    :mfacecolor       => set_mcol_v!,   # .
    :markerfacecolor  => set_mcol_v!,   # .
    :mcols            => set_mcol_v!,   # .
    :markercols       => set_mcol_v!,   # .
    :markercolors     => set_mcol_v!,   # .
    :mfacecols        => set_mcol_v!,   # .
    :mfacecolors      => set_mcol_v!,   # .
    :markerfacecolors => set_mcol_v!,   # .
    :mecol            => set_mecol_v!,  # .
    :medgecolor       => set_mecol_v!,  # .
    :markeredgecol    => set_mecol_v!,  # .
    :markeredgecolor  => set_mecol_v!   # .
    :mecols           => set_mecol_v!,  # .
    :medgecolors      => set_mecol_v!,  # .
    :markeredgecols   => set_mecol_v!,  # .
    :markeredgecolors => set_mecol_v!   # .
    )

const BARSTYLE_OPTS = Dict{Symbol, Function}(
    :ecol      => set_color!, # .
    :edgecol   => set_color!, # .
    :edgecolor => set_color!, # .
    )

const GBARSTYLE_OPTS = Dict{Symbol, Function}(
    :col        => set_color_v!, # set_style
    :color      => set_color_v!, # .
    :ecol       => set_color_v!, # .
    :edgecol    => set_color_v!, # .
    :edgecolor  => set_color_v!, # .
    :cols       => set_color_v!, # .
    :colors     => set_color_v!, # .
    :ecols      => set_color_v!, # .
    :edgecols   => set_color_v!, # .
    :edgecolors => set_color_v!, # .
    :fcol       => set_fill_v!,  # .
    :fcolor     => set_fill_v!,  # .
    :facecolor  => set_fill_v!,  # .
    :fill       => set_fill_v!,  # .
    :fcols      => set_fill_v!,  # .
    :fcolors    => set_fill_v!,  # .
    :facecolors => set_fill_v!,  # .
    :fills      => set_fill_v!,  # .
    :width      => set_width!, # .
    :binwidth   => set_width!, # .
    )

const FILLSTYLE_OPTS = Dict{Symbol, Function}(
    :col       => set_fill!, # set_style
    :color     => set_fill!, # .
    :fcol      => set_fill!, # .
    :ffill     => set_fill!, # .
    :facecol   => set_fill!, # .
    :facefill  => set_fill!, # .
    :fill      => set_fill!, # .
    :alpha     => set_alpha!, # .
    )

####
#### Options for AX_ELEMS
####

const TITLE_OPTS = Dict{Symbol, Function}(
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

const SCATTER2D_OPTS = Dict{Symbol, Function}(
    :name   => set_label!, # set_drawing
    :key    => set_label!, # .
    :label  => set_label!, # .
    :labels => set_label!, # .
    )
merge!(SCATTER2D_OPTS, GLINESTYLE_OPTS)
merge!(SCATTER2D_OPTS, GMARKERSTYLE_OPTS)
set_properties!(s::Scatter2D; opts...) = set_properties!(SCATTER2D_OPTS, s; opts...)

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
merge!(HIST2D_OPTS, FILLSTYLE_OPTS)
set_properties!(h::Hist2D; opts...) = set_properties!(HIST2D_OPTS, h; opts...)

const BAR2D_OPTS = Dict{Symbol, Function}(
    :stacked    => set_stacked!, # set_drawing
    :horiz      => set_horiz!,   # .
    :horizontal => set_horiz!,   # .
    )
merge!(BAR2D_OPTS, GBARSTYLE_OPTS)
set_properties!(gb::Bar2D; opts...) =
    set_properties!(BAR2D_OPTS, gb; opts...)

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
