module GPlot

using Parameters
using Colors
using DelimitedFiles

import Base: |>, take!, isempty

export Figure, gcf, gca, erase!,
    plot, plot!,
    title!, xtitle!, x2title!, ytitle!, y2title!

include("utils.jl")

const GP_VERBOSE    = true
const GP_BACKEND    = GLE
const GLE_APP_PATH  = "/Applications/QGLE.app/Contents/bin"
const GP_TMP_PATH   = expanduser("~/.julia/dev/GPlotExamples.jl/tmp/")
const GP_DEL_INTERM = false

const Float = Float64
const VF  = Vector{Float}
const AVF = AbstractVector{Float}
const MF  = Matrix{Float}
const ∅   = nothing
const PT_TO_CM  = 0.0352778 # 1pt in cm
const Option{T} = Union{Nothing, T}

include("types/style.jl")
include("types/drawing.jl")
include("types/figure.jl")

include("gle/dictionaries.jl")
include("gle/set_style.jl")
include("gle/set_ax.jl")

include("gle/apply_style.jl")
include("gle/apply_drawing.jl")
include("gle/apply_ax.jl")
include("gle/assemble_figure.jl")

include("set_properties.jl")
include("plot.jl")
include("ax.jl")

const GP_ALLFIGS  = Dict{String, Figure}()
const GP_CURFIG   = Ref{Option{Figure}}(nothing)
const GP_CURAXES  = Ref{Option{Axes}}(nothing)

gcf() = ifelse(isdef(GP_CURFIG.x), GP_CURFIG.x, Figure())
gca() = GP_CURAXES.x # if nothing, whatever called it will create
get_backend(f::Figure{B}) where B<:Backend = B


# XXX sandbox for now!
function Base.show(jio::IO, ::MIME"image/png", fig::Figure)
    if isdefined(Main, :IJulia) && Main.IJulia.inited
        assemble_figure(fig)
        # XXX if fig.transparency --> use -cairo option
        run(`bash -c "$(GPlot.GLE_APP_PATH)/gle -d png -vb 0 -r 200 $(GPlot.GP_TMP_PATH)/$(fig.id).gle $(GPlot.GP_TMP_PATH)/$(fig.id).png"`)
        GP_DEL_INTERM && rm("$(GPlot.GP_TMP_PATH)/$(fig.id).gle")
        write(jio, read("$(GPlot.GP_TMP_PATH)/$(fig.id).png"))
    end
end

end # module
