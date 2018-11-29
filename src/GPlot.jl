module GPlot

using Parameters
using Colors
using DelimitedFiles: writedlm

import Base: |>, take!, isempty

export Figure, gcf, gca, erase!,
    plot, plot!, legend,
    title!, xtitle!, x2title!, ytitle!, y2title!,
    preview, render, savefig,
    @t_str, @tex_str

include("utils.jl")

const GP_VERBOSE    = true
const GP_BACKEND    = GLE
const GLE_APP_PATH  = "/Applications/QGLE.app/Contents/bin/gle"
const GP_TMP_PATH   = expanduser("~/.julia/dev/GPlotExamples.jl/tmp/")
const GP_DEL_INTERM = true
const GP_SHOW_GSERR = false # show ghostscript errors (bounding box...)

const Float = Float64
const VF    = Vector{Float}
const AVF   = AbstractVector{Float}
const MF    = Matrix{Float}
const ∅     = nothing

const PT_TO_CM  = 0.0352778 # 1pt in cm
const Option{T} = Union{Nothing, T}

include("types/style.jl")
include("types/drawing.jl")
include("types/figure.jl")

include("gle/dictionaries.jl")
include("gle/set_style.jl")
include("gle/set_drawing.jl")
include("gle/set_figure.jl")

include("gle/apply_style.jl")
include("gle/apply_drawing.jl")
include("gle/apply_figure.jl")

include("set_properties.jl")
include("plot.jl")
include("ax.jl")

include("render.jl")

const GP_ALLFIGS = Dict{String, Figure}()
const GP_CURFIG  = Ref{Option{Figure}}(nothing)
const GP_CURAXES = Ref{Option{Axes}}(nothing)

"""
    gcf()

Return the current active Figure or a new figure if there isn't one.
"""
gcf() = isdef(GP_CURFIG.x) ? GP_CURFIG.x : Figure() # do not use ifelse here


"""
    gca()

Return the current active Axes and `nothing` if there isn't one.
"""
gca() = GP_CURAXES.x # if nothing, whatever called it will create


"""
    get_backend(f)

Return the backend type associated with figure `f`.
"""
get_backend(f::Figure{B}) where B<:Backend = B

end # module
