@testset "▶ types/ax                    " begin
    # CONSTRUCTORS
    a = GPlot.Axis("x")
    @test a.prefix == "x"
    @test a.ticks.prefix == "x"
    @test isnothing(a.textstyle.hei)
    @test isnothing(a.textstyle.font)
    @test isnothing(a.textstyle.color)
    @test isnothing(a.title)
    @test isnothing(a.off)
    @test isnothing(a.base)
    @test isnothing(a.lwidth)
    @test isnothing(a.grid)
    @test isnothing(a.log)
    @test isnothing(a.min)
    @test isnothing(a.max)
end

@testset "▶ /ax                         " begin
    f = Figure()
    # axis limits
    # -- without kwargs
    xlim!(0, 3); ylim!(0, 3)
    x2lim!(0, 3); y2lim!(0, 3)
    @test f.axes[1].xaxis.min  == 0.0
    @test f.axes[1].xaxis.max  == 3.0
    @test f.axes[1].x2axis.min == 0.0
    @test f.axes[1].x2axis.max == 3.0
    @test f.axes[1].yaxis.min  == 0.0
    @test f.axes[1].yaxis.max  == 3.0
    @test f.axes[1].y2axis.min == 0.0
    @test f.axes[1].y2axis.max == 3.0
    # -- with kwargs
    xlim(min=1, max=2); ylim(min=1, max=2)
    x2lim(min=1, max=2); y2lim(min=1, max=2)
    @test f.axes[1].xaxis.min  == 1.0
    @test f.axes[1].xaxis.max  == 2.0
    @test f.axes[1].x2axis.min == 1.0
    @test f.axes[1].x2axis.max == 2.0
    @test f.axes[1].yaxis.min  == 1.0
    @test f.axes[1].yaxis.max  == 2.0
    @test f.axes[1].y2axis.min == 1.0
    @test f.axes[1].y2axis.max == 2.0
    # scale
    erase!(f)
    xscale("log");
    @test f.axes[1].xaxis.log == true
    @test isnothing(f.axes[1].x2axis.log)
    x2scale("log"); yscale("log"); y2scale("log")
    @test f.axes[1].x2axis.log == true
    erase!(f)
    yscale("log")
    @test isnothing(f.axes[1].xaxis.log)
    @test f.axes[1].yaxis.log == true
    erase!(f); x2scale("log"); erase!(f); y2scale("log")
    @test f.axes[1].y2axis.log == true

    # diverse extra ones prompted by codecov
    f = Figure()
    xlim!(min=0, max=2)
    @test f.axes[1].xaxis.min == 0.0
    @test f.axes[1].xaxis.max == 2.0
    xlim(f.axes[1], 0, 2)
    @test f.axes[1].xaxis.min == 0.0
    @test f.axes[1].xaxis.max == 2.0
    xlim(0, 2)
    @test f.axes[1].xaxis.min == 0.0
    @test f.axes[1].xaxis.max == 2.0

    x2lim!(min=0, max=2)
    @test f.axes[1].x2axis.min == 0.0
    @test f.axes[1].x2axis.max == 2.0
    x2lim(f.axes[1], 0, 2)
    @test f.axes[1].x2axis.min == 0.0
    @test f.axes[1].x2axis.max == 2.0
    x2lim(0, 2)
    @test f.axes[1].x2axis.min == 0.0
    @test f.axes[1].x2axis.max == 2.0

    ylim!(min=0, max=2)
    @test f.axes[1].yaxis.min == 0.0
    @test f.axes[1].yaxis.max == 2.0
    ylim(f.axes[1], 0, 2)
    @test f.axes[1].yaxis.min == 0.0
    @test f.axes[1].yaxis.max == 2.0
    ylim(0, 2)
    @test f.axes[1].yaxis.min == 0.0
    @test f.axes[1].yaxis.max == 2.0

    y2lim!(min=0, max=2)
    @test f.axes[1].y2axis.min == 0.0
    @test f.axes[1].y2axis.max == 2.0
    y2lim(f.axes[1], 0, 2)
    @test f.axes[1].y2axis.min == 0.0
    @test f.axes[1].y2axis.max == 2.0
    y2lim(0, 2)
    @test f.axes[1].y2axis.min == 0.0
    @test f.axes[1].y2axis.max == 2.0

    erase!(gcf())
    xscale!("log")
    @test f.axes[1].xaxis.log
    @test_throws G.OptionValueError yscale!("las")
    xscale!(f.axes[1], "lin")
    @test f.axes[1].xaxis.log == false
    xscale(f.axes[1], "log")
    @test f.axes[1].xaxis.log

    erase!(gcf())
    x2scale!("log")
    @test f.axes[1].x2axis.log
    x2scale!(f.axes[1], "lin")
    @test f.axes[1].x2axis.log == false
    x2scale(f.axes[1], "log")
    @test f.axes[1].x2axis.log

    erase!(gcf())
    yscale!("log")
    @test f.axes[1].yaxis.log
    yscale!(f.axes[1], "lin")
    @test f.axes[1].yaxis.log == false
    yscale(f.axes[1], "log")
    @test f.axes[1].yaxis.log

    erase!(gcf())
    y2scale!("log")
    @test f.axes[1].y2axis.log
    y2scale!(f.axes[1], "lin")
    @test f.axes[1].y2axis.log == false
    y2scale(f.axes[1], "log")
    @test f.axes[1].y2axis.log
end

@testset "▶ apply_gle/ax                " begin
    # AXES2D
    g = G.GLE()
    f = G.Figure();
    G.add_axes2d!()
    G.apply_axes!(g, f.axes[1])

    s = String(take!(g))
    isin(s, "begin graph")
    isin(s, "scale auto")
    isin(s, "end graph")

    f.axes[1].math = true
    f.axes[1].size = (10.,8.)
    G.apply_axes!(g, f.axes[1])
    s = String(take!(g))
    isin(s, "math")
    isin(s, "size 10.0 8.0")

    # AXIS XXX
end
