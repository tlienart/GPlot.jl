#### plot with range

using GPlot

f = Figure()

x = range(-5, 5, length=100)
xs = range(-5, 5, length=20)

λ(x) = 1-exp(-sin(x) * cos(x)/x)

plot(x, λ.(x), col="blue")
scatter!(xs, λ.(xs), col="red")

ylim(-.5, .75)
xtitle("blah")
title("hello")

y2axis("off")
x2axis("off")

grid(color="lightgray", ls="-")

xticks!(-5:2.5:5)

preview()


GPlot.debug_gle(f)
