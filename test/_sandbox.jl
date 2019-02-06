#### plot with range

using GPlot

using DelimitedFiles

dat = readdlm("../GPlotExamples.jl/targets/2d-complex1/decay.dat")

f = Figure(size=(11, 8), latex=true)
bar(dat[:, 1], dat[:, 2], fcol="yellow", ecol="black", width=3)

GPlot.debug_gle(f)
