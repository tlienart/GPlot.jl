using GPlot

####
#### Simple line plot, with titles and latex
####

begin
    texpreamble = tex"""
        \usepackage[T1]{fontenc}
        \usepackage[default]{sourcesanspro}
    """
    f = Figure(texpreamble=texpreamble)

    # some silly data to display
    x1 = range(-2, stop=2, length=100)
    y1 = @. exp(-x1 * sin(x1))
    y2 = @. exp(-x1 * cos(x1))
    x2 = range(0, stop=2, length=10)
    y3 = @. sqrt(x2)
    y4 = @. exp(sin(x1)-x1^2)*x1
    x3 = range(-1, stop=1, length=15)
    y5 = @. x3^2
    y6 = @. -y5+1

    # plot things with different colors, markers etc
    plot!(x1, y1, color="darkblue", lwidth=0.02, lstyle=3, label="plot1")
    plot!(x1, y2, color="indianred")
    plot!(x2, y3, lstyle="none", marker="fcircle", msize=0.1, color="#0c88c2")
    plot!(x1, y4, color="#76116d", lwidth=0.1)
    plot!(x3, y5, ls="-", color="orange", lwidth=0.05, marker="o", mcol="red",
        label="plot2")
    plot!(x3, y6, ls="-", color="orange", lwidth=0.05, marker="•", mcol="red")

    # tex strings for the titles
    xtitle!(tex"The $x$ axis $\int_0^\infty f(x)\mathrm{d}x$", color="blue",
        fontsize=12)
    x2title(tex"$x_2$")
    y2title(tex"axis $y_2$")
    ytitle(tex"Axis $y$", fontsize=12)
    title(tex"The new title $\mathcal N$")
    legend()

    # the preview is a PNG
    # preview(f)
    # savefig(f, "../GPlotExamples.jl/tmp/atest.pdf")
end

# ============ SQROOT

using Colors

begin
    f = Figure(size=(11, 8), latex=true)
    x = range(0, stop=10, length=100);
    alphas = 1:10
    for alpha ∈ alphas
        plot!(x, sqrt.(alpha * x), col=RGB(alpha/10,0,0),
              label=tex"$\alpha=##alpha$")
    end
    xtitle!(t"$x$")
    ytitle!(t"$\sqrt{\alpha x}$")
    title!("Square Root Function")
    legend(pos="tl", fontsize=7)
    # preview(gcf())
    savefig(f, "../GPlotExamples.jl/tmp/sqroot.pdf")
end

# ============ SINE FUNCTION

begin
    x = range(-2pi, stop=2pi, length=100)
    y = sin.(x)
    f = Figure(latex=true, fontsize=8)
    plot!(x, y, col="red", smooth=true)
    title!(tex"$f(x)=\sin(x)$", dist=0.3)
    ax = gca()
    ax.math = true
    ax.xaxis.min = -2pi
    ax.xaxis.max = 2pi
    ax.xaxis.ticks.places = [-4, -3, -2, -1, 1, 2, 3, 4]/2*pi
    ax.xaxis.tickslabels.names = [t"$-2\pi$", t"$-3\pi/2$", t"$-\pi$", t"$-\pi/2$", t"$\pi/2$", t"$\pi$", t"$3\pi/2$", t"$2\pi$"]
    ax.yaxis.ticks.places = [-4, -3, -2, -1, 1, 2, 3, 4]/4
    ax.yaxis.tickslabels.names  = ["-1", "-3/4", "-1/2", "-1/4", "1/4", "1/2", "3/4", "1"]

    preview(f)
end
