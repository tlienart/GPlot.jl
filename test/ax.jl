@testset "▶ types/ax                    " begin
    # CONSTRUCTORS
    a = GPlot.Axis("x")
    @test a.prefix == "x"
    @test isnothing(a.textstyle.hei)
    @test isnothing(a.textstyle.font)
    @test isnothing(a.textstyle.color)
    @test isnothing(a.title)
    @test a.off == false
    @test isnothing(a.base)
    @test isnothing(a.lwidth)
    @test a.log == false
    @test isnothing(a.min)
    @test isnothing(a.max)

    f = Figure()
    a = GPlot.Axes2D{GPlot.GLE}(parent=f.id)
    @test a.x2axis.prefix == "x2"
    @test isempty(a.drawings)
    @test isnothing(a.title)
    @test isnothing(a.size)
    @test isnothing(a.legend)
    @test a.math == false
    @test isnothing(a.origin)

    # show
    io = IOBuffer()
    Base.show(io, MIME("text/plain"), a)
    s = String(take!(io))
    isin(s, "GPlot.Axes2D{GLE}")
    isin(s, rpad("Title:", 15) * "none")
    isin(s, rpad("N. drawings:", 15) * "0")
    isin(s, rpad("Math mode:", 15) * "false")
    isin(s, rpad("Layout origin:", 15) * "auto")
end

@testset "▶ /ax                         " begin
    f = Figure()
    # axis limits
    # -- without kwargs
    xlim(0, 3); ylim(0, 3)
    x2lim(0, 3); y2lim(0, 3)
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
    @test f.axes[1].x2axis.log == false
    x2scale("log"); yscale("log"); y2scale("log")
    @test f.axes[1].x2axis.log == true
    erase!(f)
    yscale("log")
    @test f.axes[1].xaxis.log == false
    @test f.axes[1].yaxis.log == true
    erase!(f); x2scale("log"); erase!(f); y2scale("log")
    @test f.axes[1].y2axis.log == true

    # diverse extra ones prompted by codecov
    f = Figure()
    xlim(min=0, max=2)
    @test f.axes[1].xaxis.min == 0.0
    @test f.axes[1].xaxis.max == 2.0
    xlim(0, 2)
    @test f.axes[1].xaxis.min == 0.0
    @test f.axes[1].xaxis.max == 2.0

    erase!(gcf())
    xscale("log")
    @test f.axes[1].xaxis.log
    @test_throws G.OptionValueError yscale("las")
    xscale("lin")
    @test f.axes[1].xaxis.log == false
    xscale("log")
    @test f.axes[1].xaxis.log

    # xaxis, yaxis, ... with shorthands
    erase!(gcf())
    xaxis("log")
    @test f.axes[1].xaxis.log
    xaxis("lin")
    @test !f.axes[1].xaxis.log
    y2axis("off")
    @test f.axes[1].y2axis.off
    y2axis("on")
    @test !f.axes[1].y2axis.off
    cla()
    yaxis(title="blah", log=true)
    @test f.axes[1].yaxis.log
    @test f.axes[1].yaxis.title.text == "blah"
    @test_throws G.OptionValueError x2axis("somethingweird")
    @test_throws G.OptionValueError grid(axis=["akdjf"])

    clf()
    grid(lw=0.5)
    @test f.axes[1].xaxis.ticks.linestyle.lwidth == 0.5
    @test f.axes[1].yaxis.ticks.linestyle.lwidth == 0.5

    # math
    clf()
    math()
    @test f.axes[1].math

    # more misc
    @test_throws ArgumentError xlim(5, 2)

    # test of clo
    cla()
    text("blah", (0.5,0.5))
    clo()
    @test isempty(gca().objects)

    # grid
    cla()
    grid()
    @test gca().xaxis.ticks.grid && gca().yaxis.ticks.grid
    grid("off")
    @test !gca().xaxis.ticks.grid && !gca().yaxis.ticks.grid
    grid("on")
    @test gca().xaxis.ticks.grid && gca().yaxis.ticks.grid

    # shorthands for axes
    cla()
    axis("math")
    @test gca().math
end

@testset "▶ set_prop/ax                 " begin
    f = Figure()
    yaxis(title="blah", base=0.3, min=0, max=4, log=true)
    @test f.axes[1].yaxis.title.text  == "blah"
    @test f.axes[1].yaxis.base == 0.3
    @test f.axes[1].yaxis.min == 0.0
    @test f.axes[1].yaxis.max == 4.0
    @test f.axes[1].yaxis.log
end

@testset "▶ apply_gle/ax                " begin
    # AXES2D (see also apply_title, apply_drawings, apply_legend)
    g = G.GLE()
    f = G.Figure();
    G.add_axes2d!()
    G.apply_axes!(g, f.axes[1], f.id, 1)
    s = String(take!(g))
    isin(s, "begin graph")
    isin(s, "scale auto")
    isin(s, "end graph")
    f.axes[1].math = true
    f.axes[1].size = (10.,8.)
    G.apply_axes!(g, f.axes[1], f.id, 1)
    s = String(take!(g))
    isin(s, "math")
    isin(s, "size 10.0 8.0")

    # AXIS (see also apply_ticks, apply_textstyle)
    erase!(f)
    G.add_axes2d!()
    G.apply_axes!(g, f.axes[1], f.id, 1); s = String(take!(g))
    # XXX by default subticks are off (may change)
    isin(s, "xsubticks off")
    isin(s, "ysubticks off")
    isin(s, "x2subticks off")
    isin(s, "y2subticks off")
    f.axes[1].xaxis.off = true
    G.apply_axes!(g, f.axes[1], f.id, 1); s = String(take!(g))
    isin(s, "xaxis off")
    f.axes[1].xaxis.off = false
    G.apply_axes!(g, f.axes[1], f.id, 1); s = String(take!(g))
    notisin(s, "xaxis off")
    f.axes[1].xaxis.base = 0.1
    f.axes[1].yaxis.lwidth = 2.0
    f.axes[1].x2axis.ticks.grid = true
    f.axes[1].y2axis.log = true
    f.axes[1].xaxis.min = 0.0
    f.axes[1].yaxis.max = 2.0
    G.apply_axes!(g, f.axes[1], f.id, 1); s = String(take!(g))
    isin(s, "xaxis base 0.1 min 0.0")
    isin(s, "x2axis grid")
    isin(s, "yaxis lwidth 2.0 max 2.0")
    isin(s, "y2axis log")
end
