"""
    set_properties!(dict, obj; defer_preview, opts...)

Internal function to set properties of an object `obj` given options (`opts`) of the form
`optname=value` an applying it through appropriate application function stored in the dictionary
`dict`. The keyword `defer_preview` is passed by functions that will apply a preview themselves
so that it's not repeated unnecessarily.
Note that the dictionary of property-setting-functions also contains "pre-conditioners" which
are functions that check that the values passed to properties are sensible and convert them
to sensible types if relevant. This reduces code duplication and allows to reduce specialization.
"""
function set_properties!(dict::Dict{Symbol,Pair{Function,Function}}, obj;
                         defer_preview=false, opts...)
    for optname ∈ opts.itr
        argcheck, setprop! = get(dict, optname) do
            throw(UnknownOptionError(optname, obj))
        end
        setprop!(obj, argcheck(opts[optname], optname))
    end
    defer_preview && return nothing
    return PreviewFigure(gcf())
end

set(obj; opts...) = set_properties!(obj; opts...)

####
#### Value checkers for set_properties functions the symbol corresponds to the name
#### of the option that is being modified
####

id(x, ::Symbol) = x
fl(x, ::Symbol) = fl(x)     # float conversion, see /utils.jl
not(x::Bool, ::Symbol) = !x # see for instance legend:nobox
lc(x::String, ::Symbol) = lowercase(x)
lc(x::Vector{String}, ::Symbol) = lowercase.(x)

"""
    posfl(x, s)

Internal function to check that all `x` are positive and then cast to Float64.
"""
function posfl(x, optname::Symbol)
    all(0 .< x) || throw(OptionValueError(String(optname), x))
    return fl(x)
end

"""
    posint(x, s)

Internal function to check that `x` is a positive integer.
"""
function posint(x::Int, optname::Symbol)
    0 < x || throw(OptionValueError(String(optname), x))
    return x
end

"""
    col(x, s)

Internal function to process a color, if a string is passed, it is parsed by the `Colors` package.
"""
col(c::Color, ::Symbol)   = c
col(s::String, ::Symbol)  = parse(Color, s)
col(v::Vector, s::Symbol) = col.(v, s)

"""
    opcol(x, s)

Internal function to process an optional color, i.e. `"none"` can be passed resulting in `nothing`
being passed. This is relevant for instance when setting the background color of a figure to "none"
(transparent figure). If `"none"` is passed, the current figure is checked for transparency
properties, if set to false, a warning will be raised and the color will be defaulted to `"white"`
if the transparency setting is unset, it will be set to `true`.
"""
function opcol(s::String, n::Symbol)::Option{Color}
    if lowercase(s) == "none"
        isdef(gcf().transparency) || (gcf().transparency=true)
        if !gcf().transparency
            @warn "Transparent background is only supported when the figure " *
                  "has its transparency property set to 'true'."
            return col("white", n) # fully opaque
        end
        return nothing
    end
    return col(s, n)
end
opcol(c::Color, n::Symbol) = col(c, n)

"""
    alpha(α, s)

Internal function to process an alpha parameter (transparency). The current figure is checked for
transparency properties, if set to false, a warning will be raised and the `α` will be ignored
(fully opaque). If the transparency setting is unset, it will be set to `true`.
Accepted values are strictly between `0` and `1`. For completely transparent, see using `"none"` in
the color description (for instance `Figure(bgcol="none")`).
"""
function alpha(α::Real, optname::Symbol)
    isdef(gcf().transparency) || (gcf().transparency=true)
    if !gcf().transparency
        @warn "Transparent colors are only supported when the figure " *
              "has its transparency property set to 'true'. Ignoring α."
        return 1.0 # fully opaque
    end
    0 < α < 1 || throw(OptionValueError("alpha"), α)
    return fl(α)
end

####
#### Pickers for GROUPED objects
#### --> gline, gbar, scatter, boxplot, bar
####

# this behaves like ∘ except it splats the output of g, this is useful in set_properties
# when wanting to use a set function but it has to be applied on a subfield of the object,
# then we apply a "selector" first to pick that subfield before applying the setter.
# the effect would be something like  setter(picker(obj), value) and is written (setter ⊙ picker)
⊙(f::Function, g::Function) = (λ(args...) = f(g(args...)...))

pick_lstyles(o, v) = (o.linestyles, v)
pick_mstyles(o, v) = (o.markerstyles, v)
pick_bstyles(o, v) = (o.barstyles, v)
pick_blstyle(b, v) = (b.boxstyles, v, :blstyle)
pick_mlstyle(b, v) = (b.boxstyles, v, :mlstyle)
pick_mmstyle(b, v) = (b.boxstyles, v, :mmstyle)
pick_omstyle(b, v) = (b.boxstyles, v, :omstyle)


###############################################################
####
#### Options for STYLE
####
###############################################################


const TEXTSTYLE_OPTS = Dict{Symbol,Pair{Function,Function}}(
    :font      => lc    => set_font!,      # set_style
    :fontsize  => posfl => set_hei!,       # .
    :col       => col   => set_textcolor!, # .
    :color     => col   => set_textcolor!, # .
    :textcol   => col   => set_textcolor!, # .
    :textcolor => col   => set_textcolor!, # .
    )

const LINESTYLE_OPTS = Dict{Symbol,Pair{Function,Function}}(
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

const GLINESTYLE_OPTS = Dict{Symbol,Pair{Function,Function}}(
    :ls         => id    => set_lstyles! ⊙ pick_lstyles, # set_style
    :lstyle     => id    => set_lstyles! ⊙ pick_lstyles, # .
    :linestyle  => id    => set_lstyles! ⊙ pick_lstyles, # .
    :lstyles    => id    => set_lstyles! ⊙ pick_lstyles, # .
    :linestyles => id    => set_lstyles! ⊙ pick_lstyles, # .
    :lw         => posfl => set_lwidths! ⊙ pick_lstyles, # .
    :lwidth     => posfl => set_lwidths! ⊙ pick_lstyles, # .
    :linewidth  => posfl => set_lwidths! ⊙ pick_lstyles, # .
    :lwidths    => posfl => set_lwidths! ⊙ pick_lstyles, # .
    :linewidths => posfl => set_lwidths! ⊙ pick_lstyles, # .
    :smooth     => id    => set_smooths! ⊙ pick_lstyles, # .
    :smooths    => id    => set_smooths! ⊙ pick_lstyles, # .
    :lc         => col   => set_colors! ⊙ pick_lstyles,  # .
    :col        => col   => set_colors! ⊙ pick_lstyles,  # .
    :color      => col   => set_colors! ⊙ pick_lstyles,  # .
    :cols       => col   => set_colors! ⊙ pick_lstyles,  # .
    :colors     => col   => set_colors! ⊙ pick_lstyles,  # .
    )

const GMARKERSTYLE_OPTS = Dict{Symbol,Pair{Function,Function}}(
    :marker           => lc    => set_markers! ⊙ pick_mstyles, # set_style
    :markers          => lc    => set_markers! ⊙ pick_mstyles, # .
    :ms               => posfl => set_markers! ⊙ pick_mstyles, # .
    :msize            => posfl => set_msizes! ⊙ pick_mstyles,  # .
    :msizes           => posfl => set_msizes! ⊙ pick_mstyles,  # .
    :markersize       => posfl => set_msizes! ⊙ pick_mstyles,  # .
    :markersizes      => posfl => set_msizes! ⊙ pick_mstyles,  # .
    :mc               => col   => set_mcols! ⊙ pick_mstyles,   # .
    :mcol             => col   => set_mcols! ⊙ pick_mstyles,   # .
    :markercol        => col   => set_mcols! ⊙ pick_mstyles,   # .
    :markercolor      => col   => set_mcols! ⊙ pick_mstyles,   # .
    :mcols            => col   => set_mcols! ⊙ pick_mstyles,   # .
    :markercols       => col   => set_mcols! ⊙ pick_mstyles,   # .
    :markercolors     => col   => set_mcols! ⊙ pick_mstyles,   # .
    )

const BARSTYLE_OPTS = Dict{Symbol,Pair{Function,Function}}(
    :ecol      => col => set_color!, # .
    :edgecol   => col => set_color!, # .
    :edgecolor => col => set_color!, # .
    )

const GBARSTYLE_OPTS = Dict{Symbol,Pair{Function,Function}}(
    # bar fill color (main)
    :col        => col   => set_fills! ⊙ pick_bstyles,  # set_style
    :color      => col   => set_fills! ⊙ pick_bstyles,  # .
    :cols       => col   => set_fills! ⊙ pick_bstyles,  # .
    :colors     => col   => set_fills! ⊙ pick_bstyles,  # .
    :fill       => col   => set_fills! ⊙ pick_bstyles,  # .
    :fills      => col   => set_fills! ⊙ pick_bstyles,  # .
    # edge color (secondary)
    :ecol       => col   => set_colors! ⊙ pick_bstyles, # .
    :edgecol    => col   => set_colors! ⊙ pick_bstyles, # .
    :edgecolor  => col   => set_colors! ⊙ pick_bstyles, # .
    :ecols      => col   => set_colors! ⊙ pick_bstyles, # .
    :edgecols   => col   => set_colors! ⊙ pick_bstyles, # .
    :edgecolors => col   => set_colors! ⊙ pick_bstyles, # .
    # bar width
    :width      => posfl => set_bwidth!, # .
    :bwidth     => posfl => set_bwidth!, # .
    :barwidth   => posfl => set_bwidth!, # .
    )

const FILLSTYLE_OPTS = Dict{Symbol,Pair{Function,Function}}(
    # fill color and alpha
    :col   => col   => set_fill!,  # set_style
    :color => col   => set_fill!,  # .
    :fill  => col   => set_fill!,  # .
    :alpha => alpha => set_alpha!, # .
    )


###############################################################
####
#### Options for AX_ELEMS
####
###############################################################


const TITLE_OPTS = Dict{Symbol,Pair{Function,Function}}(
    :dist => posfl => set_dist!
    )
merge!(TITLE_OPTS, TEXTSTYLE_OPTS)
set_properties!(t::Title; opts...) = set_properties!(TITLE_OPTS, t; opts...)

const LEGEND_OPTS = Dict{Symbol,Pair{Function,Function}}(
    # position of the legend
    :pos        => lc    => set_position!, # set_legend
    :position   => lc    => set_position!, # .
    # toggle legend on/off
    :off        => id    => set_off!,      # .
    :on         => not   => set_off!,      # .
    # toggle surrounding box on/off
    :nobox      => id    => set_nobox!,    # .
    :box        => not   => set_nobox!,    # .
    # specify margins (internal) and offset (external)
    :margins    => fl    => set_margins!,  # .
    :offset     => fl    => set_offset!,   # .
    # background color and alpha
    :bgcol      => opcol => set_color!,    # set_style
    :bgcolor    => opcol => set_color!,    # .
    :background => opcol => set_color!,    # .
    :bgalpha    => alpha => set_alpha!,    # .
    )
merge!(LEGEND_OPTS, TEXTSTYLE_OPTS)
set_properties!(l::Legend; opts...) = set_properties!(LEGEND_OPTS, l; opts...)

const TICKS_OPTS = Dict{Symbol,Pair{Function,Function}}(
    # ticks related
    :off        => id  => set_off!,        # set_ax_elems
    :on         => not => set_off!,        # .
    :len        => fl  => set_length!,     # .
    :length     => fl  => set_length!,     # .
    :sym        => id  => set_symticks!,   # .
    :symticks   => id  => set_symticks!,   # .
    # ticks color
    :tcol       => col => set_color!,      # .
    :tickscol   => col => set_color!,      # .
    :tickscolor => col => set_color!,      # .
    # grid mode
    :grid       => id  => set_grid!,       # .
    # labels related
    :hidelabels => id  => set_labels_off!, # set_ax_elems
    :showlabels => not => set_labels_off!, # .
    :angle      => fl  => set_angle!,      # .
    :format     => lc  => set_format!,     # .
    :shift      => fl  => set_shift!,      # .
    :dist       => id  => set_dist!,       # .
    :distance   => id  => set_dist!,
    )
merge!(TICKS_OPTS, LINESTYLE_OPTS) # ticks line
merge!(TICKS_OPTS, TEXTSTYLE_OPTS) # labels
set_properties!(t::Ticks; opts...) = set_properties!(TICKS_OPTS, t; opts...)


###############################################################
####
#### Options for DRAWINGS
####
###############################################################


const SCATTER2D_OPTS = Dict{Symbol,Pair{Function,Function}}(
    :name   => id => set_labels!, # set_drawing
    :key    => id => set_labels!, # .
    :keys   => id => set_labels!, # .
    :label  => id => set_labels!, # .
    :labels => id => set_labels!, # .
    )
merge!(SCATTER2D_OPTS, GLINESTYLE_OPTS)
merge!(SCATTER2D_OPTS, GMARKERSTYLE_OPTS)
set_properties!(s::Scatter2D; opts...) = set_properties!(SCATTER2D_OPTS, s; opts...)

const FILL2D_OPTS = Dict{Symbol,Pair{Function,Function}}(
    :from  => fl => set_xmin!,
    :min   => fl => set_xmin!,
    :xmin  => fl => set_xmin!,
    :to    => fl => set_xmax!,
    :max   => fl => set_xmax!,
    :xmax  => fl => set_xmax!,
    :key   => id => set_label!, # set_drawing
    :label => id => set_label!, # .
    )
merge!(FILL2D_OPTS, FILLSTYLE_OPTS)
set_properties!(f::Fill2D; opts...) = set_properties!(FILL2D_OPTS, f; opts...)

const HIST2D_OPTS = Dict{Symbol,Pair{Function,Function}}(
    :bins       => posint => set_bins!,    # set_drawing
    :nbins      => posint => set_bins!,    # .
    :scaling    => lc     => set_scaling!, # .
    :norm       => lc     => set_scaling!, # .
    :horiz      => id     => set_horiz!,   # .
    :horizontal => id     => set_horiz!,   # .
    :key        => id     => set_label!,   # set_drawing
    :label      => id     => set_label!,   # .
    )
merge!(HIST2D_OPTS, BARSTYLE_OPTS)
merge!(HIST2D_OPTS, FILLSTYLE_OPTS)
set_properties!(h::Hist2D; opts...) = set_properties!(HIST2D_OPTS, h; opts...)

const BAR2D_OPTS = Dict{Symbol,Pair{Function,Function}}(
    :stacked    => id => set_stacked!, # set_drawing
    :horiz      => id => set_horiz!,   # .
    :horizontal => id => set_horiz!,   # .
    :key        => id => set_labels!,  # .
    :label      => id => set_labels!,  # .
    :keys       => id => set_labels!,  # .
    :labels     => id => set_labels!,  # .
    )
merge!(BAR2D_OPTS, GBARSTYLE_OPTS)
set_properties!(gb::Bar2D; opts...) = set_properties!(BAR2D_OPTS, gb; opts...)

const BOXPLOT_OPTS = Dict{Symbol,Pair{Function,Function}}(
    # -- global toggle
    :horiz => id => set_horiz!, # set_drawing
    # -- now inside BOXSTYLES
    # box styling
    :box_width          => posfl => set_bwidths!, # set_drawing
    :box_widths         => posfl => set_bwidths!, # .
    :box_wwidth         => posfl => set_wwidths!, # .
    :box_wwidths        => posfl => set_wwidths!, # .
    :box_whisker_width  => posfl => set_wwidths!, # .
    :box_whisker_widths => posfl => set_wwidths!, # .
    # how long should the whiskers be
    :whisker            => posfl => set_wrlengths!, # set_drawing
    :whiskers           => posfl => set_wrlengths!, # .
    # what line style should be used to draw the boxes
    :box_ls         => id    => set_lstyles! ⊙ pick_blstyle,
    :box_lstyle     => id    => set_lstyles! ⊙ pick_blstyle,
    :box_lstyles    => id    => set_lstyles! ⊙ pick_blstyle,
    :box_linestyle  => id    => set_lstyles! ⊙ pick_blstyle,
    :box_linestyles => id    => set_lstyles! ⊙ pick_blstyle,
    :box_lw         => posfl => set_lwidths! ⊙ pick_blstyle,
    :box_lwidth     => posfl => set_lwidths! ⊙ pick_blstyle,
    :box_lwidths    => posfl => set_lwidths! ⊙ pick_blstyle,
    :box_linewidth  => posfl => set_lwidths! ⊙ pick_blstyle,
    :box_linewidths => posfl => set_lwidths! ⊙ pick_blstyle,
    :box_col        => col   => set_colors! ⊙ pick_blstyle,
    :box_cols       => col   => set_colors! ⊙ pick_blstyle,
    :box_color      => col   => set_colors! ⊙ pick_blstyle,
    :box_colors     => col   => set_colors! ⊙ pick_blstyle,
    # median line
    :med_ls         => id    => set_lstyles! ⊙ pick_mlstyle,
    :med_lstyle     => id    => set_lstyles! ⊙ pick_mlstyle,
    :med_lstyles    => id    => set_lstyles! ⊙ pick_mlstyle,
    :med_linestyle  => id    => set_lstyles! ⊙ pick_mlstyle,
    :med_linestyles => id    => set_lstyles! ⊙ pick_mlstyle,
    :med_lw         => posfl => set_lwidths! ⊙ pick_mlstyle,
    :med_lwidth     => posfl => set_lwidths! ⊙ pick_mlstyle,
    :med_lwidths    => posfl => set_lwidths! ⊙ pick_mlstyle,
    :med_linewidth  => posfl => set_lwidths! ⊙ pick_mlstyle,
    :med_linewidths => posfl => set_lwidths! ⊙ pick_mlstyle,
    :med_col        => col   => set_colors! ⊙ pick_mlstyle,
    :med_cols       => col   => set_colors! ⊙ pick_mlstyle,
    :med_color      => col   => set_colors! ⊙ pick_mlstyle,
    :med_colors     => col   => set_colors! ⊙ pick_mlstyle,
    # mean marker
    :mean_show         => id    => set_mshow!,
    :mean_marker       => id    => set_markers! ⊙ pick_mmstyle,
    :mean_markers      => id    => set_markers! ⊙ pick_mmstyle,
    :mean_msize        => posfl => set_msizes! ⊙ pick_mmstyle,
    :mean_msizes       => posfl => set_msizes! ⊙ pick_mmstyle,
    :mean_markersize   => posfl => set_msizes! ⊙ pick_mmstyle,
    :mean_markersizes  => posfl => set_msizes! ⊙ pick_mmstyle,
    :mean_mcol         => col   => set_mcols! ⊙ pick_mmstyle,
    :mean_mcols        => col   => set_mcols! ⊙ pick_mmstyle,
    :mean_markercol    => col   => set_mcols! ⊙ pick_mmstyle,
    :mean_markercols   => col   => set_mcols! ⊙ pick_mmstyle,
    :mean_markercolor  => col   => set_mcols! ⊙ pick_mmstyle,
    :mean_markercolors => col   => set_mcols! ⊙ pick_mmstyle,
    # outliers
    :out_show         => id    => set_mshow!,
    :out_marker       => id    => set_markers! ⊙ pick_omstyle,
    :out_markers      => id    => set_markers! ⊙ pick_omstyle,
    :out_msize        => posfl => set_msizes! ⊙ pick_omstyle,
    :out_msizes       => posfl => set_msizes! ⊙ pick_omstyle,
    :out_markersize   => posfl => set_msizes! ⊙ pick_omstyle,
    :out_markersizes  => posfl => set_msizes! ⊙ pick_omstyle,
    :out_mcol         => col   => set_mcols! ⊙ pick_omstyle,
    :out_mcols        => col   => set_mcols! ⊙ pick_omstyle,
    :out_markercol    => col   => set_mcols! ⊙ pick_omstyle,
    :out_markercols   => col   => set_mcols! ⊙ pick_omstyle,
    :out_markercolor  => col   => set_mcols! ⊙ pick_omstyle,
    :out_markercolors => col   => set_mcols! ⊙ pick_omstyle,
    )
set_properties!(bp::Boxplot; opts...) = set_properties!(BOXPLOT_OPTS, bp; opts...)

const HEATMAP_OPTS = Dict{Symbol,Pair{Function,Function}}(
    :cmap     => col => set_cmap!,
    :colormap => col => set_cmap!,
    )
set_properties!(h::Heatmap; opts...) = set_properties!(HEATMAP_OPTS, h; opts...)


###############################################################
####
#### Options for OBJECTS
####
###############################################################


const TEXT2D_OPTS = Dict{Symbol,Pair{Function,Function}}(
    :pos      => id    => set_position!, # set_drawing
    :position => id    => set_position!, # .
    )
merge!(TEXT2D_OPTS, TEXTSTYLE_OPTS)
set_properties!(t::Text2D; opts...) = set_properties!(TEXT2D_OPTS, t; opts...)

const STRAIGHTLINE2D_OPTS = Dict{Symbol,Pair{Function,Function}}(
    )
merge!(STRAIGHTLINE2D_OPTS, LINESTYLE_OPTS)
set_properties!(t::StraightLine2D; opts...) = set_properties!(STRAIGHTLINE2D_OPTS, t; opts...)

const BOX2D_OPTS = Dict{Symbol,Pair{Function,Function}}(
    :pos      => id    => set_position!, # set legend
    :position => id    => set_position!, # .
    :nobox    => id    => set_nobox!,    # .
    :box      => not   => set_nobox!,    # .
    :fill     => opcol => set_fill!,     # .
    :alpha    => alpha => set_alpha!,    # .
    )
merge!(BOX2D_OPTS, LINESTYLE_OPTS)
set_properties!(b::Box2D; opts...) = set_properties!(BOX2D_OPTS, b; opts...)

const COLORBAR_OPTS = Dict{Symbol,Pair{Function,Function}}(
    :pixels     => posint => set_pixels!,   # set object
    :res        => posint => set_pixels!,   # .
    :resolution => posint => set_pixels!,   # .
    :nobox      => id     => set_nobox!,    # set legend
    :box        => not    => set_nobox!,    # .
    :pos        => id     => set_position!, # set object
    :position   => id     => set_position!, # .
    :offset     => fl     => set_offset!,   # set legend
    :size       => posfl  => set_size!,     # set figure
    :ticks      => fl     => set_ticks!,    # set object
    :labels     => id     => set_labels!,
    )
merge!(COLORBAR_OPTS, TICKS_OPTS)
merge!(COLORBAR_OPTS, TEXTSTYLE_OPTS)
set_properties!(b::Colorbar; opts...) = set_properties!(COLORBAR_OPTS, b; opts...)

###############################################################
####
#### Options for AX*
####
###############################################################


const  AXES_OPTS = Dict{Symbol,Pair{Function,Function}}(
    :size  => fl => set_size!,  # set figure
    :title => id => set_title!, # set ax
    :off   => id => set_off!,   # set axelems
    )
set_properties!(a::Axes; opts...) = set_properties!(AXES_OPTS, a; opts...)

const AXIS_OPTS = Dict{Symbol,Pair{Function,Function}}(
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


###############################################################
####
#### Options for FIGURE
####
###############################################################


const FIGURE_OPTS = Dict{Symbol,Pair{Function,Function}}(
    :size         => posfl => set_size!,         # set_figure
    :tex          => id    => set_texlabels!,    # .
    :hastex       => id    => set_texlabels!,    # .
    :latex        => id    => set_texlabels!,    # .
    :haslatex     => id    => set_texlabels!,    # .
    :texscale     => lc    => set_texscale!,     # .
    :alpha        => id    => set_transparency!, # .
    :transparent  => id    => set_transparency!, # .
    :transparency => id    => set_transparency!, # .
    :preamble     => id    => set_texpreamble!,  # .
    :texpreamble  => id    => set_texpreamble!,  # .
    :col          => opcol => set_color!,        # set_style
    :color        => opcol => set_color!,        # .
    :bgcol        => opcol => set_color!,        # .
    :bgcolor      => opcol => set_color!,        # .
    :background   => opcol => set_color!,        # .
    :bgalpha      => alpha => set_alpha!,        # .
    )
merge!(FIGURE_OPTS, TEXTSTYLE_OPTS)
set_properties!(f::Figure; opts...) = set_properties!(FIGURE_OPTS, f; opts...)
