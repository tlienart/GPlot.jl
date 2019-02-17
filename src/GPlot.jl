#__precompile__(false) # see also warmup=false

module GPlot

using Parameters
using Colors
using DelimitedFiles: writedlm

import Base: |>, take!, isempty

export Figure, gcf, gca, clf!, cla!, clf, cla, erase!,
    # Layout
    layout!, layout, subplot,
    # Drawings
    plot!, scatter!, fill_between!, hist!, bar!,
    plot, scatter, fill_between, hist, bar,
    # Axis / Axes
    # -- titles
    title!, xtitle!, x2title!, ytitle!, y2title!,
    xlabel!, x2label!, ylabel!, y2label!, legend!,
    title, xtitle, x2title, ytitle, y2title,
    xlabel, x2label, ylabel, y2label, legend,
    # -- lims
    xlim!, x2lim!, ylim!, y2lim!,
    xlim, x2lim, ylim, y2lim,
    # -- ticks
    xticks!, x2ticks!, yticks!, y2ticks!,
    xticks, x2ticks, yticks, y2ticks,
    # -- scale
    xscale!, x2scale!, yscale!, y2scale!,
    xscale, x2scale, yscale, y2scale,
    # -- misc
    xaxis!, x2axis!, yaxis!, y2axis!,
    xaxis, x2axis, yaxis, y2axis,
    grid!, math!,
    grid, math,
    # Preview / rendering / saving
    preview, render, savefig, isempty, debug_gle,
    # Simple macros for tex strings
    @t_str, @tex_str

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
    "VERBOSE"      => true,         # whether to write things in the REPL
    "TMP_PATH"     => mktempdir(),  # where intermedate files will be stored
    "DEL_INTERM"   => true,         # delete intermediate files
    "SHOW_GSERR"   => false,        # GLE related, ghostscript errors
    "PALETTE"      => PALETTE_1,    # default color palette
    "SIZE_PALETTE" => length(PALETTE_1),
    )

const ∅   = nothing
const AV  = AbstractVector
const AVM = AbstractVecOrMat
const AM  = AbstractMatrix
const AVR = AbstractVector{<:Real}

const PT_TO_CM   = 0.0352778         # 1pt in cm
const Option{T}  = Union{Nothing, T} # a useful type for optional values
const CanMiss{T} = Union{Missing, T}

include("utils.jl")

# Type of objects
include("types/style.jl")
include("types/drawing.jl")
include("types/ax_elems.jl")
include("types/ax.jl")
include("types/figure.jl")

# Naming of properties: specific and shared
include("set_prop/dicts_gle.jl")
include("set_prop/dicts_shared.jl")

# Set properties of objects
include("set_prop/style.jl")
include("set_prop/drawing.jl")
include("set_prop/ax_elems.jl")
include("set_prop/ax.jl")
include("set_prop/figure.jl")
include("set_prop/properties.jl")

# Write objects to GLE buffer
include("apply_gle/style.jl")
include("apply_gle/drawing.jl")
include("apply_gle/ax_elems.jl")
include("apply_gle/ax.jl")
include("apply_gle/figure.jl")

# Main call for elements
include("drawing.jl")
include("ax.jl")
include("ax_elem.jl")
include("figure.jl")
include("layout.jl")

# Rendering of things (preview/savefig)
include("render.jl")

# Extra few utils now that all types have been defined
include("utils2.jl")

# warmup script
include("init.jl")

end # module
