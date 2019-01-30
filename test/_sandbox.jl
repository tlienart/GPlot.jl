#### plot with range

using GPlot

############### multiple line, multiple labels (TODO: color range)

f = Figure()

x = 0.1:0.1:5
y1 = @. x^2 / exp(x)
y2 = @. x^3 / exp(x)

plot(x, [y1 y2], label=["plot1", "plot2"])
legend()

preview(gcf())

#GPlot.debug_gle(gcf())

############### xlims, etc
