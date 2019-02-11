#### plot with range

using GPlot

f = Figure()

x = range(-5, 5, length=100)
y = @. 1-exp(-sin(x) * cos(x)/x)

plot(x, y, col="blue")

ylim(-1, 1)

#y2axis("off")

preview()

GPlot.debug_gle(f)
