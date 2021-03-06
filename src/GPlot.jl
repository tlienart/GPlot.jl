#__precompile__(false) # see also warmup=false

module GPlot

using DocStringExtensions: SIGNATURES

using Parameters
using Colors
using DelimitedFiles: writedlm
using Statistics: quantile, mean

import Base: |>, take!, isempty

export Figure, gcf, gca, clf, cla, clo, cll, erase!,
    continuous_preview, preview,
    # General set function
    set, set_palette,
    # Layout
    layout, subplot,
    # Drawings
    plot!, scatter!, fill_between!, hist!, bar!,  # append mode
    plot, scatter, fill_between, hist, bar,       # new/overwrite mode
    # -- special drawings
    boxplot, heatmap, heatmap_ticks,
    # -- 3D drawings
    plot3!, scatter3!,
    plot3, scatter3,
    # Objects
    text, vline, hline, line, box, colorbar,
    # Axis / Axes
    # -- legend
    legend,
    # -- titles
    title, xtitle, x2title, ytitle, y2title,
    xlabel, x2label, ylabel, y2label,
    # -- lims
    xlim, x2lim, ylim, y2lim,
    # -- ticks
    xticks, x2ticks, yticks, y2ticks,
    # -- scale
    xscale, x2scale, yscale, y2scale,
    # -- misc
    axis, xaxis, x2axis, yaxis, y2axis, grid, math,
    # Preview / rendering / saving
    preview, savefig, isempty, debug_gle,
    # Simple macros for tex strings and color strings
    @t_str, @tex_str, @c_str

const PALETTE_1 = [ # imitated from tableau 10 - 2
    RGB(0.33, 0.47, 0.64),
    RGB(0.90, 0.57, 0.26),
    RGB(0.82, 0.37, 0.36),
    RGB(0.51, 0.70, 0.69),
    RGB(0.42, 0.62, 0.35),
    RGB(0.91, 0.79, 0.37),
    RGB(0.66, 0.49, 0.62),
    RGB(0.95, 0.63, 0.66),
    RGB(0.59, 0.46, 0.38),
    RGB(0.72, 0.69, 0.67) ]

const GP_ENV = Dict{String, Any}(
    "BACKEND"      => nothing,           # set in __init__
    "HAS_BACKEND"  => false,             # set in __init__ (hopefully to true)
    "VERBOSE"      => true,              # whether to write things in the REPL
    "TMP_PATH"     => mktempdir(),       # where intermedate files will be stored
    "DEL_INTERM"   => true,              # delete intermediate files
    "SHOW_GSERR"   => false,             # GLE related, ghostscript errors
    "PALETTE"      => PALETTE_1,         # default color palette
    "SIZE_PALETTE" => length(PALETTE_1),
    "CONT_PREVIEW" => true,              # whether to continuously preview or not
    "FORCE_PREVIEW" => false,            # even if cont prev is false (see render)
    )

# ain't nobody got time to write long type names
const ∅   = nothing
const AV  = AbstractVector
const AVM = AbstractVecOrMat
const AM  = AbstractMatrix
const AVR = AV{<:Real}
const T2F = NTuple{2,Float64}
const T3F = NTuple{3,Float64}
const T2R = NTuple{2,Real}
const T3R = NTuple{3,Real}

const PT_TO_CM   = 0.0352778         # 1pt in cm
const Option{T}  = Union{Nothing, T} # a useful type for optional values
const CanMiss{T} = Union{Missing, T}

include("utils.jl")

# Type of objects
include("types/style.jl")
include("types/drawing.jl")
include("types/drawing2.jl")
include("types/drawing3d.jl")
include("types/ax_elems.jl")
include("types/legend.jl")
include("types/object.jl")
include("types/ax.jl")
include("types/figure.jl")

# Naming of properties: specific and shared
include("set_prop/dicts_gle.jl")
include("set_prop/dicts_shared.jl")

# Set properties of objects
include("set_prop/style.jl")
include("set_prop/drawing.jl")
include("set_prop/object.jl")
include("set_prop/ax_elems.jl")
include("set_prop/legend.jl")
include("set_prop/ax.jl")
include("set_prop/figure.jl")
include("set_prop/properties.jl")

# Write objects to GLE buffer
include("apply_gle/style.jl")
include("apply_gle/drawing.jl")
include("apply_gle/drawing2.jl")
include("apply_gle/drawing3d.jl")
include("apply_gle/object.jl")
include("apply_gle/ax_elems.jl")
include("apply_gle/legend.jl")
include("apply_gle/ax.jl")
include("apply_gle/figure.jl")

# Main call for elements
include("drawing.jl")   # plot, scatter, fill, hist, bar
include("drawing2.jl")  # boxplot, heatmap
include("drawing3d.jl") # plot3, scatter3, surface
include("object.jl")    # text, hline, vline, box
include("ax.jl")
include("ax_elem.jl")
include("legend.jl")
include("figure.jl")
include("layout.jl")
include("gle_sub.jl")

# Rendering of things (preview/savefig)
include("render.jl")

# Extra few utils now that all types have been defined
include("utils2.jl")

include("build.jl")

# warmup script
include("init.jl")

end # module
