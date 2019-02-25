using GPlot, Colors, Random; PREVIEW = false; SAVEFIG = true; SAVEPATH = "../GPlotExamples.jl/examples/";

continuous_preview(false) # considerable speedup...

####
#### Simple line plot, no latex
#### NOTE: this is super quick (after precomp)
#### because there's no latex compilation pass
####

begin
# dummy data
    x1 = range(-2, stop=2, length=100)
    y1 = @. exp(-x1 * sin(x1))
    y2 = @. exp(-x1 * cos(x1))

    t = @elapsed begin
        f = Figure("simple_notex", reset=true)
        # plot things with different colors, markers etc
        plot(x1, y1, color="darkblue", lwidth=0.02)
        plot(x1, y2, color="darkred", lwidth=0.02) # will overwrite previous
        plot!(x1, y1, color="darkblue", lwidth=0.02)
        # -----
        PREVIEW && preview(f)
        SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
    end; println("$(f.id)...done in $(round(t, digits=2))s")
end

####
#### Simple line plot, with titles and latex
####

begin
    # dummy data
    x1 = range(-2, stop=2, length=100)
    y1 = @. exp(-x1 * sin(x1))
    y2 = @. exp(-x1 * cos(x1))
    x2 = range(0, stop=2, length=10)
    y3 = @. sqrt(x2)
    y4 = @. exp(sin(x1)-x1^2)*x1
    x3 = range(-1, stop=1, length=15)
    y5 = @. x3^2
    y6 = @. -y5+1

    t = @elapsed begin
        texpreamble = tex"""
            \usepackage[T1]{fontenc}
            \usepackage[default]{sourcesanspro}
        """
        f = Figure("simple_tex", texpreamble=texpreamble, reset=true)
        # plot things with different colors, markers etc
        plot!(x1, y1, color="darkblue", lwidth=0.02, lstyle=3)
        plot!(x1, y2, color="indianred")
        plot!(x2, y3, lstyle="none", marker="fcircle", msize=0.1, color="#0c88c2")
        plot!(x1, y4, color="#76116d", lwidth=0.1)
        plot!(x3, y5, ls="-", color="orange", lwidth=0.05, marker="o", label="yolo")
        plot!(x3, y6, ls="-", color="darkcyan", lwidth=0.05, marker=".")
        # tex strings for the titles
        xtitle!(tex"The $x$ axis $\int_0^\infty f(x)\mathrm{d}x$", color="blue",
            fontsize=12)
        x2title(tex"$x_2$")
        y2title(tex"axis $y_2$")
        ytitle(tex"Axis $y$", fontsize=12)
        title(tex"The new title $\mathcal N$")
        legend()
        # -----
        PREVIEW && preview(f)
        SAVEFIG && savefig(f; format="pdf", path=SAVEPATH)
    end; println("$(f.id)...done in $(round(t, digits=2))s")
end

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
    # -----
    PREVIEW && preview(gcf())
    SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
end; println("$(f.id)...done in $(round(t, digits=2))s")

####
#### Simple line plots with centered axis for sine with latex
#### [GLE EXAMPLE]
####

begin
    # dummy data
    x = range(-2pi, 2pi, length=100)
    y = sin.(x)

    t = @elapsed begin
        f = Figure("sine_tex", latex=true, fontsize=8, reset=true)
        plot!(x, y, col="red", smooth=true)
        title!(tex"$f(x)=\sin(x)$", dist=0.3)
        ax = gca()
        ax.math = true
        ax.xaxis.min = -2pi
        ax.xaxis.max = 2pi
        ax.xaxis.ticks.places = [-4, -3, -2, -1, 1, 2, 3, 4]/2*pi
        ax.xaxis.ticks.labels = GPlot.TicksLabels(names=[t"$-2\pi$", t"$-3\pi/2$", t"$-\pi$", t"$-\pi/2$", t"$\pi/2$", t"$\pi$", t"$3\pi/2$", t"$2\pi$"])
        ax.yaxis.ticks.places = [-4, -3, -2, -1, 1, 2, 3, 4]/4
        ax.yaxis.ticks.labels = GPlot.TicksLabels(names=["-1", "-3/4", "-1/2", "-1/4", "1/4", "1/2", "3/4", "1"])
        # -----
        PREVIEW && preview(gcf())
        SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
    end; println("$(f.id)...done in $(round(t, digits=2))s")
end

####
#### Simple histogram with pdf normalisation and pdf fit added
####

begin
    # dummy data
    x = randn(10_000)
    xx = range(-4, 4, length=100)
    y  = @. exp(-xx^2/2)/sqrt(2pi)

    t = @elapsed begin
        f = Figure("simple_hist_notex", reset=true)
        hist(x, fill="CornflowerBlue", color="white", scaling="pdf", nbins=50)
        plot!(xx, y)
        # -----
        PREVIEW && preview(f)
        SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
    end; println("$(f.id)...done in $(round(t, digits=2))s")
end

####
#### Fill between lines with transparency
#### NOTE: alpha=true must be there otherwise GLE errors!
####

begin
    # dummy data
    x = 0.1:0.1:5
    y1 = @. x^2 / exp(x)
    y2 = @. x^3 / exp(x)
    y3 = @. exp(-x^2)

    t = @elapsed begin
        f = Figure("simple_fill_transp_notex", alpha=true, reset=true)
        GPlot.add_axes2d!()
        fill_between!(x, y1, y2, alpha=0.5)
        fill_between!(x, 0, y3, color="red", alpha=0.5)
        # -----
        PREVIEW && preview(f)
        SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
    end; println("$(f.id)...done in $(round(t, digits=2))s")
end

####
#### Simple log plot, no latex
####

begin
    # dummy data
    x = range(1, stop=1000, length=100)
    y = @. log(x)

    t = @elapsed begin
        f = Figure("simple_logscale_notex", reset=true)
        plot(x, y, lstyle="--", lw=0.1)
        xscale!("log")
        # -----
        PREVIEW && preview(f)
        SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
    end; println("$(f.id)...done in $(round(t, digits=2))s")
end

####
#### Simple bar, no latex
####

begin
    # dummy data
    y = [50, 10, 20, 30, 5, 100]

    t = @elapsed begin
        f = Figure("simple_bar_notex", reset=true)
        bar(y, fill="indianred", color="orange", horiz=true)
        ylim!(0.5, 6.5)
        # -----
        PREVIEW && preview(f)
        SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
    end; println("$(f.id)...done in $(round(t, digits=2))s")
end

####
#### Simple grouped bar plot, no tex
####

begin
    # dummy data
    y = [10, 20, 15, 50]
    δ = [5, 3, 7, 10]
    y2 = y .+ δ
    x = 1:length(y)

    for stacked ∈ [true, false]
        t = @elapsed begin
            f = Figure("simple_gbar_stacked=$(stacked)_notex", reset=true)
            bar(x, y, y2; stacked=stacked,
                fills=["darkgreen", "cyan"],
                colors=["white", "white"])
            # -----
            PREVIEW && preview(f)
            SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
        end; println("$(f.id)...done in $(round(t, digits=2))s")
    end
end

####
#### Axis modifications: ticks, lims
####

begin
    x = range(0, stop=2, length=10)
    y = @. x^2 / exp(x)

    t = @elapsed begin
        f = Figure("simple_lim_ticks_notex", reset=true)

        plot(x, y, lw=0.02, smooth=false)

        xlim(min=-0.5, max=2.5)
        ylim(min=-0.5, max=1.0)

        xticks([0.0, 1.5], ["A", "BB"])
        yticks([-0.2, 0.2, 0.8], ["C", "dd", "ee"], color="blue")

        x2ticks([0.5, 1.0], tickscol="indianred")

        PREVIEW && preview(f)
        SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
    end; println("$(f.id)...done in $(round(t, digits=2))s")
end

####
#### Simple line plot with scatter and axis manips
####

begin
    x = range(-5, 5, length=100)
    xs = range(-5, 5, length=20)

    t = @elapsed begin
        f = Figure("simple_scatter_notex", reset=true)

        λ(x) = 1-exp(-sin(x) * cos(x)/x)

        plot(x, λ.(x), col="blue")
        scatter!(xs, λ.(xs), col="red")

        ylim(-.5, .75)

        y2axis("off")
        x2axis("off")

        grid()
        xticks(-5:2.5:5, tickscol="lightgray", angle=45)
        yticks(-.5:0.25:.75, tickscol="lightgray")

        PREVIEW && preview(f)
        SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
    end; println("$(f.id)...done in $(round(t, digits=2))s")
end

####
#### Missing values
####

begin
    x  = range(-1, 1, length=18)
    y  = @. exp(-x^2*cos(10x))
    Random.seed!(0)
    mask = [rand()<0.25 for i ∈ eachindex(y)]
    ym = convert(Vector{GPlot.CanMiss{Float64}}, y)
    ym[mask] .= missing

    t = @elapsed begin
        f = Figure("simple_withmissing_notex", reset=true)
        plot(x, ym)
        PREVIEW && preview(f)
        SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
    end; println("$(f.id)...done in $(round(t, digits=2))s")
end

####
#### Butterfly plot
####

begin
    t = range(0, 12pi, length=5000);
    r = @. exp(cos(t)) - 2*cos(4*t) + sin(t/12)^5;
    x = @. r * cos(t);
    y = @. r * sin(t);

    t = @elapsed begin
        f = Figure("butterfly_notex", reset=true)
        plot(x, y)
        math!()
        PREVIEW && preview(f)
        SAVEFIG && savefig(f, format="pdf", path=SAVEPATH)
    end; println("$(f.id)...done in $(round(t, digits=2))s")
end

####
#### Legend styling (and implicit)
####

begin
    t = @elapsed begin
        f = Figure("legend_styling_notex", reset=true)

        plot(tan, 0, pi/2)
        scatter!(sin, 0, pi/2)
        plot!(cos, 0, pi/2)
        ylim(0, 2)

        legend(font="tt", fontsize=12, offset=(1,1), nobox=false, bgcol="blue")
    end; println("$(f.id)...done in $(round(t, digits=2))s")
end
