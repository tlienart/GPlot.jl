module GPlot

using Parameters
using Colors

using DelimitedFiles: writedlm

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
const GP_SHOW_GSERR = false # show ghostscript errors (bounding box...)

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
include("gle/set_figure.jl")

include("gle/apply_style.jl")
include("gle/apply_drawing.jl")
include("gle/apply_figure.jl")

include("set_properties.jl")
include("plot.jl")
include("ax.jl")

const GP_ALLFIGS  = Dict{String, Figure}()
const GP_CURFIG   = Ref{Option{Figure}}(nothing)
const GP_CURAXES  = Ref{Option{Axes}}(nothing)

gcf() = ifelse(isdef(GP_CURFIG.x), GP_CURFIG.x, Figure())
gca() = GP_CURAXES.x # if nothing, whatever called it will create
get_backend(f::Figure{B}) where B<:Backend = B


global call_counter = 0

# XXX sandbox for now! extract the run bit.
function Base.show(shio::IO, ::MIME"image/png", fig::Figure)
    global call_counter
    cairo, tex = "", ""
    isdef(fig.transparency) && fig.transparency && (cairo = "-cairo")
    isdef(fig.texlabels) && fig.texlabels && (tex = "-tex")
    gle   = "$(GLE_APP_PATH)/gle"
    f_in  = "$(GP_TMP_PATH)/$(fig.id).gle"
    f_out = "$(GP_TMP_PATH)/$(fig.id).png"
    nout  = ifelse(GP_SHOW_GSERR, "", "> $(GP_TMP_PATH)/log.log 2>&1")
    gle_command = "$gle -d png -vb 0 -r 200 $cairo $tex $f_in $f_out $nout"
    should_display = (isdefined(Main, :Atom) && Main.Atom.PlotPaneEnabled.x) ||
                     (isdefined(Main, :IJulia) && Main.IJulia.inited)
    if should_display
        assemble_figure(fig)
#        try
        run(`bash -c "$gle_command"`)
        isfile(joinpath(GP_TMP_PATH, "$(fig.id).log")) && error("Something failed when trying to compile, most likely the LaTeX is not right.")
        write(shio, read(f_out))
        GP_DEL_INTERM && rm(f_in)
    end
    return
end

end # module
