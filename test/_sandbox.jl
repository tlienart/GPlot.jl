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

# NOTE could not directly read single column file so would only be partial support
# so folks would have to readdlm and then hist...
f = Figure()
plot(:c1, :c2, path=joinpath(@__DIR__, "_filetest.csv"), lwidth=0.05)

preview()

#savefig(f, format="pdf", path="/Users/tlienart/Desktop/")


preview()

GPlot.debug_gle(f)
