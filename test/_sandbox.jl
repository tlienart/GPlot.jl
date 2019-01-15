#### plot with range

using GPlot

f = Figure()

x = 0.1:0.1:5
y1 = @. x^2 / exp(x)
y2 = @. x^3 / exp(x)

plot(x, [y1 y2], label=["plot1", "plot2"])
legend()

preview(gcf())

#GPlot.debug_gle(gcf())

f = Figure()
x = randn(1000)
hist(x, fill="CornflowerBlue", color="white", scaling="pdf")

xx = range(-4, 4, length=100)
y  = @. exp(-xx^2/2)/sqrt(2pi)
plot!(xx, y)

preview(f)

GPlot.debug_gle(f)
