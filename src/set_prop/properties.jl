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
        argcheck, setprop! = get(dict, optname) do
            throw(UnknownOptionError(optname, obj))
        end
        setprop!(obj, argcheck(opts[optname], optname))
    end
    return obj
end

####
#### Options for STYLE
####

id(x, ::Symbol) = x

function posfl(x::Union{Real, AVR}, optname::Symbol)
    all(0 .< x) || throw(OptionValueError(String(optname), x))
    fl(x)
end

const TEXTSTYLE_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :font     => id => set_font!,  # set_style
    :fontsize => posfl => set_hei!,   # .
    :col      => id => set_color!, # .
    :color    => id => set_color!  # .
    )

const LINESTYLE_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :ls        => id => set_lstyle!, # set_style
    :lstyle    => id => set_lstyle!, # .
    :linestyle => id => set_lstyle!, # .
    :lw        => posfl => set_lwidth!, # .
    :lwidth    => posfl => set_lwidth!, # .
    :linewidth => posfl => set_lwidth!, # .
    :smooth    => id => set_smooth!, # .
    :col       => id => set_color!,  # .
    :color     => id => set_color!,  # .
    )

const GLINESTYLE_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :ls         => id => set_lstyles!, # set_style
    :lstyle     => id => set_lstyles!, # .
    :linestyle  => id => set_lstyles!, # .
    :lstyles    => id => set_lstyles!, # .
    :linestyles => id => set_lstyles!, # .
    :lw         => posfl => set_lwidths!, # .
    :lwidth     => posfl => set_lwidths!, # .
    :linewidth  => posfl => set_lwidths!, # .
    :lwidths    => posfl => set_lwidths!, # .
    :linewidths => posfl => set_lwidths!, # .
    :smooth     => id => set_smooths!, # .
    :smooths    => id => set_smooths!, # .
    :col        => id => set_colors!,  # .
    :color      => id => set_colors!,  # .
    :cols       => id => set_colors!,  # .
    :colors     => id => set_colors!,  # .
    )

const GMARKERSTYLE_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :marker           => id => set_markers!, # set_style
    :markers          => id => set_markers!, # .
    :msize            => posfl => set_msizes!,  # .
    :msizes           => posfl => set_msizes!,  # .
    :markersize       => posfl => set_msizes!,  # .
    :markersizes      => posfl => set_msizes!,  # .
    :mcol             => id => set_mcols!,   # .
    :markercol        => id => set_mcols!,   # .
    :markercolor      => id => set_mcols!,   # .
    :mfacecol         => id => set_mcols!,   # .
    :mfacecolor       => id => set_mcols!,   # .
    :markerfacecolor  => id => set_mcols!,   # .
    :mcols            => id => set_mcols!,   # .
    :markercols       => id => set_mcols!,   # .
    :markercolors     => id => set_mcols!,   # .
    :mfacecols        => id => set_mcols!,   # .
    :mfacecolors      => id => set_mcols!,   # .
    :markerfacecolors => id => set_mcols!,   # .
    )

const BARSTYLE_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :ecol      => id => set_color!, # .
    :edgecol   => id => set_color!, # .
    :edgecolor => id => set_color!, # .
    )

const GBARSTYLE_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :col        => id => set_colors!, # set_style
    :color      => id => set_colors!, # .
    :ecol       => id => set_colors!, # .
    :edgecol    => id => set_colors!, # .
    :edgecolor  => id => set_colors!, # .
    :cols       => id => set_colors!, # .
    :colors     => id => set_colors!, # .
    :ecols      => id => set_colors!, # .
    :edgecols   => id => set_colors!, # .
    :edgecolors => id => set_colors!, # .
    :fcol       => id => set_fills!,  # .
    :fcolor     => id => set_fills!,  # .
    :facecolor  => id => set_fills!,  # .
    :fill       => id => set_fills!,  # .
    :fcols      => id => set_fills!,  # .
    :fcolors    => id => set_fills!,  # .
    :facecolors => id => set_fills!,  # .
    :fills      => id => set_fills!,  # .
    :width      => posfl => set_width!, # .
    :binwidth   => posfl => set_width!, # .
    )

const FILLSTYLE_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :col       => id => set_fill!, # set_style
    :color     => id => set_fill!, # .
    :fcol      => id => set_fill!, # .
    :ffill     => id => set_fill!, # .
    :facecol   => id => set_fill!, # .
    :facefill  => id => set_fill!, # .
    :fill      => id => set_fill!, # .
    :alpha     => id => set_alpha!, # .
    )

####
#### Options for AX_ELEMS
####

const TITLE_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :dist   => id => set_dist!
    )
merge!(TITLE_OPTS, TEXTSTYLE_OPTS)
set_properties!(t::Title; opts...) = set_properties!(TITLE_OPTS, t; opts...)

const LEGEND_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :pos      => id => set_position!, # set_drawing
    :position => id => set_position!, # .
    :fontsize => posfl => set_hei!,
    )
#XXX merge!(LEGEND_OPTS, TEXTSTYLE_OPTS)
set_properties!(l::Legend; opts...) = set_properties!(LEGEND_OPTS, l; opts...)

const TICKS_OPTS = Dict{Symbol, Pair{Function, Function}}(
    # ticks related
    :off        => id => set_off!,        # set_ax_elems
    :hideticks  => id => set_off!,        # .
    :len        => id => set_length!,     # .
    :length     => id => set_length!,     # .
    :sym        => id => set_symticks!,   # .
    :symticks   => id => set_symticks!,   # .
    :tickscol   => id => set_tickscolor!, # .
    :tickscolor => id => set_tickscolor!, # .
    :grid       => id => set_grid!,       # .
    # labels related
    :hidelabels => id => set_labels_off!, # set_ax_elems
    :angle      => id => set_angle!,      # .
    :format     => id => set_format!,     # .
    :shift      => id => set_shift!,      # .
    :dist       => id => set_dist!,       # .
    )
merge!(TICKS_OPTS, LINESTYLE_OPTS) # ticks line
merge!(TICKS_OPTS, TEXTSTYLE_OPTS) # labels
set_properties!(t::Ticks; opts...) = set_properties!(TICKS_OPTS, t; opts...)

####
#### Options for DRAWINGS
####

const SCATTER2D_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :name   => id => set_label!, # set_drawing
    :key    => id => set_label!, # .
    :label  => id => set_label!, # .
    :labels => id => set_label!, # .
    )
merge!(SCATTER2D_OPTS, GLINESTYLE_OPTS)
merge!(SCATTER2D_OPTS, GMARKERSTYLE_OPTS)
set_properties!(s::Scatter2D; opts...) = set_properties!(SCATTER2D_OPTS, s; opts...)

const FILL2D_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :from => id => set_xmin!,
    :min  => id => set_xmin!,
    :xmin => id => set_xmin!,
    :to   => id => set_xmax!,
    :max  => id => set_xmax!,
    :xmax => id => set_xmax!,
    )
merge!(FILL2D_OPTS, FILLSTYLE_OPTS)
set_properties!(f::Fill2D; opts...) = set_properties!(FILL2D_OPTS, f; opts...)

const HIST2D_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :bins       => id => set_bins!,    # set_drawing
    :nbins      => id => set_bins!,    # .
    :scaling    => id => set_scaling!, # .
    :norm       => id => set_scaling!, # .
    :horiz      => id => set_horiz!,   # .
    :horizontal => id => set_horiz!,   # .
    )
merge!(HIST2D_OPTS, BARSTYLE_OPTS)
merge!(HIST2D_OPTS, FILLSTYLE_OPTS)
set_properties!(h::Hist2D; opts...) = set_properties!(HIST2D_OPTS, h; opts...)

const BAR2D_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :stacked    => id => set_stacked!, # set_drawing
    :horiz      => id => set_horiz!,   # .
    :horizontal => id => set_horiz!,   # .
    )
merge!(BAR2D_OPTS, GBARSTYLE_OPTS)
set_properties!(gb::Bar2D; opts...) =
    set_properties!(BAR2D_OPTS, gb; opts...)

####
#### Options for FIGURE
####

const AXIS_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :title  => id => set_title!,  # set_ax
    :base   => id => set_base!,   # .
    :min    => id => set_min!,    # .
    :max    => id => set_max!,    # .
    :log    => id => set_log!,    # .
    :lwidth => posfl => set_lwidth!, # set_style
    :off    => id => set_off!,    # set_ax_elems
    )
merge!(AXIS_OPTS, TEXTSTYLE_OPTS)
set_properties!(a::Axis; opts...) = set_properties!(AXIS_OPTS, a; opts...)

####
#### Options for FIGURE
####

const FIGURE_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :size         => id => set_size!,         # set_figure
    :tex          => id => set_texlabels!,    # .
    :hastex       => id => set_texlabels!,    # .
    :latex        => id => set_texlabels!,    # .
    :haslatex     => id => set_texlabels!,    # .
    :texscale     => id => set_texscale!,     # .
    :alpha        => id => set_transparency!, # .
    :transparent  => id => set_transparency!, # .
    :transparency => id => set_transparency!, # .
    :preamble     => id => set_texpreamble!,  # .
    :texpreamble  => id => set_texpreamble!,  # .
    )
merge!(FIGURE_OPTS, TEXTSTYLE_OPTS)
set_properties!(f::Figure; opts...) = set_properties!(FIGURE_OPTS, f; opts...)
