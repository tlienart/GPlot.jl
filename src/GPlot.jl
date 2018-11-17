#module GPlot

using Parameters
using Colors
using DelimitedFiles
using Random

import Base.show,
       Base.|>

include("utils.jl")

const GP_VERBOSE = true
const GP_BACKEND = GLE

include("types/style.jl")
include("types/drawing.jl")
include("types/figure.jl")

# --
include("gle/apply_style.jl")
include("gle/apply_drawing.jl")
include("gle/apply_ax.jl")

include("gle/assemble_figure.jl")

#include("gnuplot/apply_figure.jl")

# --

include("plot.jl")

const GP_ALLFIGS = Dict{String, Figure}()
const GP_CURFIG = Ref{String}("")

###########
# XXX
f = plot(randn(10, 2))
l = f.axes[1].elements[1]
g = GLE() # should be part of f
apply_line2d(g, l)
# XXX
###########

const GLE_APP_PATH = "/Applications/QGLE.app/Contents/bin"



# XXX temporary fill in
function Base.show(io::IO, ::MIME"image/png", fig::Figure)
    isjupyter && write(io, read("sandbox/age.png"))
end

#end # module
