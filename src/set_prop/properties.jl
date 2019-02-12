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
function set_properties!(dict::Dict{Symbol,Pair{Function,Function}}, obj; opts...)
    for optname ∈ opts.itr
        argcheck, setprop! = get(dict, optname) do
            throw(UnknownOptionError(optname, obj))
        end
        setprop!(obj, argcheck(opts[optname], optname))
    end
    return obj
end

####
#### Value checkers for set_properties functions
####

id(x, ::Symbol) = x

fl(x, ::Symbol) = fl(x)

function posfl(x, optname::Symbol)
    all(0 .< x) || throw(OptionValueError(String(optname), x))
    fl(x)
end

function posint(x::Int, optname::Symbol)
    0 < x || throw(OptionValueError(String(optname), x))
    x
end

col(c::Color, ::Symbol)     = c
col(s::String, ::Symbol)    = try_parse_color(s)
col(v::Vector, s::Symbol)   = col.(v, s)
col2(c::Colorant, ::Symbol) = c
col2(s::String, ::Symbol)   = try_parse_colorant(s)
col2(v::Vector, s::Symbol)  = col2.(v, s)

####
#### Options for STYLE
####

const TEXTSTYLE_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :font     => id    => set_font!,  # set_style
    :fontsize => posfl => set_hei!,   # .
    :col      => col   => set_color!, # .
    :color    => col   => set_color!  # .
    )

const LINESTYLE_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :ls        => id    => set_lstyle!, # set_style
    :lstyle    => id    => set_lstyle!, # .
    :linestyle => id    => set_lstyle!, # .
    :lw        => posfl => set_lwidth!, # .
    :lwidth    => posfl => set_lwidth!, # .
    :linewidth => posfl => set_lwidth!, # .
    :smooth    => id    => set_smooth!, # .
    :col       => col   => set_color!,  # .
    :color     => col   => set_color!,  # .
    )

const GLINESTYLE_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :ls         => id    => set_lstyles!, # set_style
    :lstyle     => id    => set_lstyles!, # .
    :linestyle  => id    => set_lstyles!, # .
    :lstyles    => id    => set_lstyles!, # .
    :linestyles => id    => set_lstyles!, # .
    :lw         => posfl => set_lwidths!, # .
    :lwidth     => posfl => set_lwidths!, # .
    :linewidth  => posfl => set_lwidths!, # .
    :lwidths    => posfl => set_lwidths!, # .
    :linewidths => posfl => set_lwidths!, # .
    :smooth     => id    => set_smooths!, # .
    :smooths    => id    => set_smooths!, # .
    :col        => col   => set_colors!,  # .
    :color      => col   => set_colors!,  # .
    :cols       => col   => set_colors!,  # .
    :colors     => col   => set_colors!,  # .
    )

const GMARKERSTYLE_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :marker           => id    => set_markers!, # set_style
    :markers          => id    => set_markers!, # .
    :msize            => posfl => set_msizes!,  # .
    :msizes           => posfl => set_msizes!,  # .
    :markersize       => posfl => set_msizes!,  # .
    :markersizes      => posfl => set_msizes!,  # .
    :mcol             => col   => set_mcols!,   # .
    :markercol        => col   => set_mcols!,   # .
    :markercolor      => col   => set_mcols!,   # .
    :mfacecol         => col   => set_mcols!,   # .
    :mfacecolor       => col   => set_mcols!,   # .
    :markerfacecolor  => col   => set_mcols!,   # .
    :mcols            => col   => set_mcols!,   # .
    :markercols       => col   => set_mcols!,   # .
    :markercolors     => col   => set_mcols!,   # .
    :mfacecols        => col   => set_mcols!,   # .
    :mfacecolors      => col   => set_mcols!,   # .
    :markerfacecolors => col   => set_mcols!,   # .
    )

const BARSTYLE_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :ecol      => col => set_color!, # .
    :edgecol   => col => set_color!, # .
    :edgecolor => col => set_color!, # .
    )

const GBARSTYLE_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :col        => col   => set_colors!, # set_style
    :color      => col   => set_colors!, # .
    :ecol       => col   => set_colors!, # .
    :edgecol    => col   => set_colors!, # .
    :edgecolor  => col   => set_colors!, # .
    :cols       => col   => set_colors!, # .
    :colors     => col   => set_colors!, # .
    :ecols      => col   => set_colors!, # .
    :edgecols   => col   => set_colors!, # .
    :edgecolors => col   => set_colors!, # .
    :fcol       => col   => set_fills!,  # .
    :fcolor     => col   => set_fills!,  # .
    :facecolor  => col   => set_fills!,  # .
    :fill       => col   => set_fills!,  # .
    :fcols      => col   => set_fills!,  # .
    :fcolors    => col   => set_fills!,  # .
    :facecolors => col   => set_fills!,  # .
    :fills      => col   => set_fills!,  # .
    :width      => posfl => set_width!, # .
    :binwidth   => posfl => set_width!, # .
    )

const FILLSTYLE_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :col       => col2 => set_fill!, # set_style
    :color     => col2 => set_fill!, # .
    :fcol      => col2 => set_fill!, # .
    :ffill     => col2 => set_fill!, # .
    :facecol   => col2 => set_fill!, # .
    :facefill  => col2 => set_fill!, # .
    :fill      => col2 => set_fill!, # .
    :alpha     => id   => set_alpha!, # .
    )

####
#### Options for AX_ELEMS
####

const TITLE_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :dist => posfl => set_dist!
    )
merge!(TITLE_OPTS, TEXTSTYLE_OPTS)
set_properties!(t::Title; opts...) = set_properties!(TITLE_OPTS, t; opts...)

const LEGEND_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :pos      => id    => set_position!, # set_drawing
    :position => id    => set_position!, # .
    :fontsize => posfl => set_hei!,
    )
#XXX merge!(LEGEND_OPTS, TEXTSTYLE_OPTS)
set_properties!(l::Legend; opts...) = set_properties!(LEGEND_OPTS, l; opts...)

const TICKS_OPTS = Dict{Symbol, Pair{Function, Function}}(
    # ticks related
    :off        => id    => set_off!,        # set_ax_elems
    :hideticks  => id    => set_off!,        # .
    :len        => posfl => set_length!,     # .
    :length     => posfl => set_length!,     # .
    :sym        => id    => set_symticks!,   # .
    :symticks   => id    => set_symticks!,   # .
    :tickscol   => col   => set_tickscolor!, # .
    :tickscolor => col   => set_tickscolor!, # .
    :grid       => id    => set_grid!,       # .
    # labels related
    :hidelabels => id => set_labels_off!, # set_ax_elems
    :angle      => fl => set_angle!,      # .
    :format     => id => set_format!,     # .
    :shift      => fl => set_shift!,      # .
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
    :from => fl => set_xmin!,
    :min  => fl => set_xmin!,
    :xmin => fl => set_xmin!,
    :to   => fl => set_xmax!,
    :max  => fl => set_xmax!,
    :xmax => fl => set_xmax!,
    )
merge!(FILL2D_OPTS, FILLSTYLE_OPTS)
set_properties!(f::Fill2D; opts...) = set_properties!(FILL2D_OPTS, f; opts...)

const HIST2D_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :bins       => posint => set_bins!,    # set_drawing
    :nbins      => posint => set_bins!,    # .
    :scaling    => id     => set_scaling!, # .
    :norm       => id     => set_scaling!, # .
    :horiz      => id     => set_horiz!,   # .
    :horizontal => id     => set_horiz!,   # .
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
    :title  => id    => set_title!,  # set_ax
    :base   => posfl => set_base!,   # .
    :min    => fl    => set_min!,    # .
    :max    => fl    => set_max!,    # .
    :log    => id    => set_log!,    # .
    :lwidth => posfl => set_lwidth!, # set_style
    :off    => id    => set_off!,    # set_ax_elems
    )
merge!(AXIS_OPTS, TEXTSTYLE_OPTS)
set_properties!(a::Axis; opts...) = set_properties!(AXIS_OPTS, a; opts...)

####
#### Options for FIGURE
####

const FIGURE_OPTS = Dict{Symbol, Pair{Function, Function}}(
    :size         => posfl => set_size!,         # set_figure
    :tex          => id    => set_texlabels!,    # .
    :hastex       => id    => set_texlabels!,    # .
    :latex        => id    => set_texlabels!,    # .
    :haslatex     => id    => set_texlabels!,    # .
    :texscale     => id    => set_texscale!,     # .
    :alpha        => id    => set_transparency!, # .
    :transparent  => id    => set_transparency!, # .
    :transparency => id    => set_transparency!, # .
    :preamble     => id    => set_texpreamble!,  # .
    :texpreamble  => id    => set_texpreamble!,  # .
    )
merge!(FIGURE_OPTS, TEXTSTYLE_OPTS)
set_properties!(f::Figure; opts...) = set_properties!(FIGURE_OPTS, f; opts...)
