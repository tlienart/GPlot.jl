#### plot with range

using GPlot

erase!(gcf())

x = 0:0.1:10
y = @. x^2

plot(x, y)

preview(gcf())
