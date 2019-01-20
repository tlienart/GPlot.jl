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

############### bar

f = Figure()

y = [10, 20, 15, 50]
δ = [5, 3, 7, 10]
y2 = y .+ δ
x = 1:length(y)

bar(x, y, y2; stacked=true,
    fills=["darkgreen", "cyan"],
    colors=["white", "white"])

preview(f)

GPlot.debug_gle(f)

f = Figure()

y = [10, 20, 15, 50]
δ = [5, 3, 7, 10]
y2 = y .+ δ
x = 1:length(y)

bar(x, y, y2;
    fills=["darkgreen", "cyan"],
    colors=["white", "white"])

preview(f)
