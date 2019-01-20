module GPlot

using Parameters
using Colors
using DelimitedFiles: writedlm

import Base: |>, take!, isempty

export Figure, gcf, gca, erase!,
    # Drawings
    plot, plot!, hist, hist!, bar, bar!, fill_between!,
    # Axis / Axes
    title!, xtitle!, x2title!, ytitle!, y2title!, legend!,
    title, xtitle, x2title, ytitle, y2title, legend,
    xlim!, xlim, ylim!, ylim,
    xscale!, xscale, yscale!, yscale,
    # Preview / rendering / saving
    preview, render, savefig, isempty,
    @t_str, @tex_str

const GP_ENV = Dict{String, Any}(
    "VERBOSE"    => true,
    "BACKEND"    => nothing,
    "GLE_PATH"   => "/Applications/QGLE.app/Contents/bin/gle",
    "TMP_PATH"   => mktempdir(),
    "DEL_INTERM" => true,
    "SHOW_GSERR" => false
    )

include("utils.jl")

GP_ENV["BACKEND"] = GLE

const AS  = AbstractString
const ∅   = nothing
const ARR = AbstractRange{<:Real}
const AVR = AbstractVector{<:Real}
const MR  = Matrix{<:Real}

const PT_TO_CM  = 0.0352778 # 1pt in cm
const Option{T} = Union{Nothing, T}

include("types/style.jl")
include("types/drawing.jl")
include("types/ax_elems.jl")
include("types/ax.jl")
include("types/figure.jl")

include("gle/dictionaries.jl")

include("gle/set/set_style.jl")
include("gle/set/set_drawing.jl")
include("gle/set/set_ax_elems.jl")
include("gle/set/set_ax.jl")
include("gle/set/set_figure.jl")

include("gle/apply/apply_style.jl")
include("gle/apply/apply_drawing.jl")
include("gle/apply/apply_ax_elems.jl")
include("gle/apply/apply_ax.jl")
include("gle/apply/apply_figure.jl")

include("set_properties.jl")
include("plot.jl")
include("ax.jl")

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
get_backend(f::Figure{B}) where B <: Backend = B

end # module
