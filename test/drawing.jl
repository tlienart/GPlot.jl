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

@testset "Drawing -- /drawing           " begin
    # SCATTER2D
    # -- basic plot
    x = randn(5)
    y = randn(5)
    plot(x, y)
    el = gca().drawings[1]
    @test el isa GPlot.Scatter2D
    @test el.xy == hcat(x, y)
    plot!(2x, 2y)
    el2 = gca().drawings[2]
    @test el2.xy == hcat(2x, 2y)
    plot!(1:3, exp.(1:3), lw=2, ls="--") # "--" is 9 in GLE
    el3 = gca().drawings[3]
    @test el3.xy == hcat(1:3, exp.(1:3))
    @test el3.linestyle.lstyle == 9
    @test el3.linestyle.lwidth == 2.0
    plot!(exp.(1:3), marker="o")
    el4 = gca().drawings[4]
    @test el4.xy == el3.xy
    @test isnothing(el4.linestyle.lstyle) # XXX default will be "-"
    @test el4.markerstyle.marker == "circle"

    erase!(gcf())
    # -- multiplot
    plot(x, y, 2y, 3y)
    el = gca().drawings[1]
    @test el.xy == hcat(x, y, 2y, 3y)

    # FILL2D
    erase!(gcf())
    gcf().transparency = true
    x = 1:5
    y1 = exp.(x)
    y2 = sin.(x)
    fill_between(x, y1, y2, alpha=0.5)
    fill_between!(x, 0, y2, color="red", alpha=0.5)
    el1 = gca().drawings[1]
    el2 = gca().drawings[2]
    @test el1.xy1y2 == hcat(x, y1, y2)
    @test el2.fillstyle.color == RGBA{Float64}(1.0,0.0,0.0,0.5)
end
