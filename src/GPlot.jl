module GPlot

using Parameters
using Colors
using DelimitedFiles: writedlm

import Base: |>, take!, isempty

export Figure, gcf, gca, erase!,
    # Drawings
    plot, plot!, fill_between, fill_between!, hist, hist!,
    bar, bar!,
    # Axis / Axes
    # -- title
    title!, xtitle!, x2title!, ytitle!, y2title!, legend!,
    title, xtitle, x2title, ytitle, y2title, legend,
    # -- lims
    xlim!, x2lim!, ylim!, y2lim!,
    xlim, x2lim, ylim, y2lim,
    # -- ticks
    xticks!, x2ticks!, yticks!, y2ticks!,
    xticks, x2ticks, yticks, y2ticks,
    # -- scale
    xscale!, x2scale!, yscale!, y2scale!,
    xscale, x2scale, yscale, y2scale,
    # Preview / rendering / saving
    preview, render, savefig, isempty,
    @t_str, @tex_str

if !isdefined(Base, :isnothing)
    isnothing(o) = o === nothing
    export isnothing
end

const GP_ENV = Dict{String, Any}(
    "VERBOSE"    => true,
    "TMP_PATH"   => mktempdir(),
    "DEL_INTERM" => true,
    "SHOW_GSERR" => false
    )

include("utils.jl")

const ∅   = nothing
const ARR = AbstractRange{<:Real}
const AVR = AbstractVector{<:Real}
const MR  = Matrix{<:Real}

const PT_TO_CM  = 0.0352778         # 1pt in cm
const Option{T} = Union{Nothing, T} # a useful type for optional values

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

# Rendering of things (preview/savefig)
include("render.jl")

GP_ENV["ALLFIGS"] = Dict{String, Figure}()
GP_ENV["CURFIG"]  = nothing
GP_ENV["CURAXES"] = nothing

"""
    gcf()

Return the current active Figure or a new figure if there isn't one.
"""
gcf() = isdef(GP_ENV["CURFIG"]) ? GP_ENV["CURFIG"] : Figure() # no ifelse here

"""
    gca()

Return the current active Axes and `nothing` if there isn't one.
"""
gca() = GP_ENV["CURAXES"] # if nothing, whatever called it will create

"""
    get_backend(f)

Return the backend type associated with figure `f`.
"""
get_backend(f::Figure{B}=gcf()) where {B} = B

# -------

include("init.jl")

end # module
