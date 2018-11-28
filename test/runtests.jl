#using LaTeXStrings #---> is actually slow, just using `raw` works better.

using GPlot, Test

texpreamble = raw"""
    \usepackage[T1]{fontenc}
    \usepackage[default]{sourcesanspro}
    """
f = Figure(texpreamble=texpreamble)

x1 = range(-2, stop=2, length=100)
y1 = @. exp(-x1 * sin(x1))
y2 = @. exp(-x1 * cos(x1))
x2 = range(0, stop=2, length=10)
y3 = @. sqrt(x2)
y4 = @. exp(sin(x1)-x1^2)*x1
x3 = range(-1, stop=1, length=15)
y5 = @. x3^2
y6 = @. -y5+1

plot!(x1, y1, color="darkblue", lwidth=0.02, lstyle=3, label="plot1")
plot!(x1, y2, color="indianred")
plot!(x2, y3, lstyle="none", marker="fcircle", msize=0.1, color="#0c88c2")
plot!(x1, y4, color="#76116d", lwidth=0.1)
plot!(x3, y5, ls="-", color="orange", lwidth=0.05, marker="o", mcol="red", label="plot2")
plot!(x3, y6, ls="-", color="orange", lwidth=0.05, marker="•", mcol="red")

xtitle!(raw"The $x$ axis $\int_0^\infty f(x)\mathrm{d}x$")

x2title!(raw"$x_2$")
y2title!(raw"axis $y_2$")
ytitle!(raw"$y$")
title!(raw"The new title $\mathcal N$")

legend()

preview(f)

savefig(f, "../GPlotExamples.jl/tmp/atest.pdf")


# ============

using GPlot

x = range(-2pi, stop=2pi, length=100)
y = sin.(x)

f = Figure(latex=true, fontsize=8)
plot!(x, y)

title!(raw"$f(x)=\sin(x)$")

# XXX
gca().math = true
gca().xaxis.min = -2pi
gca().xaxis.max = 2pi
gca().xaxis.ticks = [-4, -3, -2, -1, 1, 2, 3, 4]
gca().xaxis.tickslabels = [raw"$-2\pi$", raw"$-3\pi/2$", raw"$-\pi$", raw"$-\pi/2$", raw"$\pi/2$", raw"$\pi$", raw"$3\pi/2$", raw"$2\pi$"]

preview(f)
