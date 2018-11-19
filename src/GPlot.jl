#module GPlot

using Parameters
using Colors
using DelimitedFiles
using Random

import Base.show,
       Base.|>,
       Base.take!

include("utils.jl")

const GP_VERBOSE = true
const GP_BACKEND = GLE

include("types/style.jl")
include("types/drawing.jl")
include("types/figure.jl")

include("gle/dictionaries.jl")
include("gle/set_property.jl")

include("gle/apply_style.jl")
include("gle/apply_drawing.jl")
include("gle/apply_ax.jl")
include("gle/assemble_figure.jl")

#include("gnuplot/apply_figure.jl")

include("set_properties.jl")
include("plot.jl")


const GP_ALLFIGS  = Dict{String, Figure}()
const GP_CURFIG   = Ref{String}("")
const GP_TMP_PATH = expanduser("~/.julia/dev/GPlot.jl/sandbox/") # mktempdir()

get_curfig() = GP_ALLFIGS[GP_CURFIG.x]

###########
# XXX
f = Figure("test")
erase!(f)

x1 = range(-2, stop=2, length=100)
y1 = @. exp(-x1 * sin(x1))
y2 = @. exp(-x1 * cos(x1))
x2 = range(0, stop=2, length=25)
y3 = @. sqrt(x2)

plot!(x1, y1, color="darkblue", lwidth=0.02, lstyle=2)
plot!(x1, y2, color="indianred")
plot!(x2, y3, marker="fcircle")

assemble_figure(f)

const GLE_APP_PATH = "/Applications/QGLE.app/Contents/bin"

run(`bash -c "$GLE_APP_PATH/gle -d pdf $GP_TMP_PATH/test.gle $GP_TMP_PATH/test.pdf"`)
# XXX
###########

# XXX temporary fill in
function Base.show(io::IO, ::MIME"image/png", fig::Figure)
    isjupyter && write(io, read("sandbox/age.png"))
end

#end # module
