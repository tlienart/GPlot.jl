@testset "Axis -- types/ax              " begin
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

@testset "Axis -- /ax                   " begin
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
end

# @testset "Axes -- types/ax              " begin
#     # CONSTRUCTORS
#     a = G.Axes2D{G.GLE}()
#     @test a isa G.Axes{G.GLE}
#     @test a.drawings isa Vector{G.Drawing}
#     @test isempty(a.drawings)
#     @test !G.isdef(a.title)
#     @test !G.isdef(a.size)
#     @test !G.isdef(a.math)
#     @test !G.isdef(a.legend)
# end
