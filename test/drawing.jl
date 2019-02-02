@testset "Drawing -- types/drawing      " begin
    # SCATTER2D
    s = GPlot.Scatter2D(xy=rand(Float32, 3, 2))
    @test s isa GPlot.Drawing2D
    @test s isa GPlot.Drawing
    @test s isa GPlot.Scatter2D{Matrix{Float32}}
    @test isnothing(s.linestyle.lwidth)
    @test isnothing(s.markerstyle.color)
    @test isnothing(s.label)
    s = GPlot.Scatter2D(xy=rand(3, 2), linestyle=GPlot.LineStyle(lwidth=0.5))
    @test s.linestyle.lwidth == 0.5

    # FILL2D
    f = GPlot.Fill2D(xy1y2=rand(Float16, 5, 3))
    @test f isa GPlot.Drawing2D
    @test f isa GPlot.Fill2D{Matrix{Float16}}
    @test isnothing(f.xmin)
    @test isnothing(f.xmax)
    @test f.fillstyle.color == colorant"cornflowerblue"

    # HIST2D
    h = GPlot.Hist2D(x=rand(Int16, 5))
    @test h isa GPlot.Drawing2D
    @test h isa GPlot.Hist2D{Vector{Int16}}
    @test isnothing(h.barstyle.color)
    @test h.horiz == false
    @test isnothing(h.bins)
    @test isnothing(h.scaling)

    # GROUPEDBAR2D
    b = GPlot.BarStyle()
    g = GPlot.GroupedBar2D(xy=rand(Float32, 5, 3), barstyle=[b, b])
    @test g isa GPlot.Drawing2D
    @test g isa GPlot.GroupedBar2D{Matrix{Float32}}
    @test g.stacked == false
    @test g.horiz == false
end
