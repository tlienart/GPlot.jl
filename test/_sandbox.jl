#### plot with range

using GPlot

f = Figure()

x = 0.1:0.1:5
y = @. x^2 / exp(x)

plot(x, y)

preview(gcf())
