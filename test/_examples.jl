using GPlot
using Colors

PREVIEW = false
SAVEFIG = true

SAVEPATH = "../GPlotExamples.jl/examples/"

####
#### Simple line plot, no latex
#### NOTE: this is super quick because there's no latex compilation pass
####
t = @elapsed begin
    f = Figure("simple_notex", reset=true)

    # some silly data to display
    x1 = range(-2, stop=2, length=100)
    y1 = @. exp(-x1 * sin(x1))
    y2 = @. exp(-x1 * cos(x1))

    # plot things with different colors, markers etc
    plot(x1, y1, color="darkblue", lwidth=0.02)
    plot(x1, y2, color="darkred", lwidth=0.02) # will overwrite previous
    plot!(x1, y1, color="darkblue", lwidth=0.02)

    # the preview is a PNG
    PREVIEW && preview(f)
    SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
end; println("$(f.id)...done in $(round(t, digits=2))s")

####
#### Simple line plot, with titles and latex
####

t = @elapsed begin
    texpreamble = tex"""
        \usepackage[T1]{fontenc}
        \usepackage[default]{sourcesanspro}
    """
    f = Figure("simple_tex", texpreamble=texpreamble, reset=true)

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
    plot!(x1, y1, color="darkblue", lwidth=0.02, lstyle=3,
            label="plot1")
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
    PREVIEW && preview(f)
    SAVEFIG && savefig(f; format="pdf", path=SAVEPATH)
end; println("$(f.id)...done in $(round(t, digits=2))s")

####
#### Simple multiple line plots (in for loop) for square root with latex
#### [GLE EXAMPLE]
####

t = @elapsed begin
    f = Figure("sqroot_tex", size=(11, 8), latex=true, reset=true)
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

    PREVIEW && preview(gcf())
    SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
end; println("$(f.id)...done in $(round(t, digits=2))s")

####
#### Simple line plots with centered axis for sine with latex
#### [GLE EXAMPLE]
####

t = @elapsed begin
    f = Figure("sine_tex", latex=true, fontsize=8, reset=true)
    x = range(-2pi, 2pi, length=100)
    y = sin.(x)
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

    PREVIEW && preview(gcf())
    SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
end; println("$(f.id)...done in $(round(t, digits=2))s")

####
#### Simple histogram with pdf normalisation and pdf fit added
####

t = @elapsed begin
    f = Figure("simple_hist_notex", reset=true)
    x = randn(10_000)
    hist(x, fill="CornflowerBlue", color="white", scaling="pdf", nbins=50)

    xx = range(-4, 4, length=100)
    y  = @. exp(-xx^2/2)/sqrt(2pi)
    plot!(xx, y)

    PREVIEW && preview(f)
    SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
end; println("$(f.id)...done in $(round(t, digits=2))s")


####
#### Fill between lines with transparency
#### NOTE: alpha=true must be there otherwise GLE errors!
####

t = @elapsed begin
    f = Figure("simple_fill_transp_notex", alpha=true, reset=true)

    x = 0.1:0.1:5
    y1 = @. x^2 / exp(x)
    y2 = @. x^3 / exp(x)

    GPlot.add_axes2d!()
    fill_between!(gca(), [x y1 y2], alpha=0.5)

    y3 = @. exp(-x^2)
    fill_between!(x, 0, y3, color="red", alpha=0.5)

    PREVIEW && preview(f)
    SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
end; println("$(f.id)...done in $(round(t, digits=2))s")

####
#### Simple log plot, no latex
####

t = @elapsed begin
    f = Figure("simple_logscale_notex", reset=true)

    x = range(1, stop=1000, length=100)
    y = @. log(x)

    plot(x, y, lstyle="--", lw=0.1)
    xscale!("log")

    PREVIEW && preview(f)
    SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
end; println("$(f.id)...done in $(round(t, digits=2))s")

####
#### Simple bar, no latex
####

t = @elapsed begin
    f = Figure("simple_bar_notex", reset=true)

    y = [50, 10, 20, 30, 5, 100]

    bar(y, fill="indianred", color="orange", horiz=true)

    ylim!(0.5, 6.5)

    PREVIEW && preview(f)
    SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
end; println("$(f.id)...done in $(round(t, digits=2))s")

####
#### Simple grouped bar plot, no tex
####

for stacked ∈ [true, false]
    t = @elapsed begin
        f = Figure("simple_gbar_stacked=$(stacked)_notex", reset=true)

        y = [10, 20, 15, 50]
        δ = [5, 3, 7, 10]
        y2 = y .+ δ
        x = 1:length(y)

        bar(x, y, y2; stacked=stacked,
            fills=["darkgreen", "cyan"],
            colors=["white", "white"])

        PREVIEW && preview(f)
        SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
    end; println("$(f.id)...done in $(round(t, digits=2))s")
end
