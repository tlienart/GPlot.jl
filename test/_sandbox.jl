#### plot with range

using GPlot
#using ColorBrewer

f = Figure()

x = [1, 2, 3, 4, 5, 6, 7]
y = [1, 4, missing, 16, 25, missing, 10]

plot(x, y)

preview()

x = randn(500)
xm = convert(Vector{GPlot.CanMiss{Float64}}, x)

hist(xm)

preview()

#savefig(f, format="pdf", path="/Users/tlienart/Desktop/")

GPlot.debug_gle(f)
