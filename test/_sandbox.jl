#### plot with range

using GPlot

############### multiple line, multiple labels (TODO: color range)

f = Figure()

x = 0.1:0.1:5
y1 = @. x^2 / exp(x)
y2 = @. x^3 / exp(x)

isempty(f)

subplot(231)
plot(x, [y1 y2], label=["plot1", "plot2"])
legend()
title("Plot1")
xlabel("blah")
ylabel("blah")

subplot(232)
plot(x, [y1 y2], label=["plot1", "plot2"])
legend()
xlabel("blah")
title("Plot2")
ylabel("gazorpazorp")

subplot(233); title("plot3")
subplot(234); title("plot4")
subplot(235); title("plot5")
subplot(236); title("plot6")

preview(gcf())

savefig(f, format="pdf", path="/Users/tlienart/Desktop/")

GPlot.debug_gle(gcf())

erase!(f)
