@testset "▶ types/drawing               " begin
    # SCATTER2D
    s = GPlot.Scatter2D(rand(Float64, 3, 2))
    @test s isa GPlot.Drawing2D
    @test s isa GPlot.Drawing
    @test s isa GPlot.Scatter2D
    @test isnothing(s.linestyle[1].lwidth)
    @test isnothing(s.markerstyle[1].color)
    @test isempty(s.label)
    s = GPlot.Scatter2D(rand(3, 2))
    s.linestyle[1].lwidth = 0.5
    @test s.linestyle[1].lwidth == 0.5
    @test isnothing(s.xsym)
    @test isnothing(s.ysym)
    @test isnothing(s.path)

    # SCATTER2D (from file)
    s = G.Scatter2D(:c1, [:c2, :c3], "blah")
    @test isempty(s.xy)
    @test length(s.linestyle) == 2
    @test length(s.markerstyle) == 2
    @test s.xsym == :c1
    @test s.ysym == [:c2, :c3]
    @test s.path == "blah"

    # FILL2D
    f = GPlot.Fill2D(xy1y2=rand(Float16, 5, 3))
    @test f isa GPlot.Drawing2D
    @test f isa GPlot.Fill2D
    @test isnothing(f.xmin)
    @test isnothing(f.xmax)
    @test f.fillstyle.fill == colorant"cornflowerblue"

    # HIST2D
    h = G.Hist2D(x=G.fl(rand(Int16, 5)))
    @test h isa GPlot.Drawing2D
    @test h isa GPlot.Hist2D
    @test isnothing(h.barstyle.color)
    @test h.horiz == false
    @test isnothing(h.bins)
    @test isnothing(h.scaling)

    # GROUPEDBAR2D
    f = Figure()
    bar(rand(Float32, 5, 3))
    g = f.axes[1].drawings[1]
    @test g isa GPlot.Drawing2D
    @test g isa GPlot.Bar2D
    @test g.stacked == false
    @test g.horiz == false
end

@testset "▶ /drawing                    " begin
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
    @test el3.linestyle[1].lstyle == 9
    @test el3.linestyle[1].lwidth == 2.0
    plot!(exp.(1:3), marker="o")
    el4 = gca().drawings[4]
    @test el4.xy == el3.xy
    @test isnothing(el4.linestyle[1].lstyle) # XXX default will be "-"
    @test el4.markerstyle[1].marker == "circle"

    # -- if there's more than 20 points go to smooth
    @test isnothing(el.linestyle[1].smooth) # only 5 points
    z = randn(25)
    plot(z, z)
    @test gca().drawings[1].linestyle[1].smooth

    erase!(gcf())
    plot!(1:5, 2)
    el = gca().drawings[1]
    @test el.xy == hcat(1:5, collect(1:5)*0 .+ 2)
    plot!(1:5, exp.(1:5), sin.(1:5))
    el2 = gca().drawings[2]
    @test el2.xy == hcat(1:5, exp.(1:5), sin.(1:5))
    xy = rand(Float32, 5, 3)
    plot(xy)
    @test gca().drawings[1].xy == xy

    erase!(gcf())
    # -- multiplot
    plot(x, y, 2y, 3y)
    el = gca().drawings[1]
    @test el.xy == hcat(x, y, 2y, 3y)

    erase!(gcf())
    # -- scatterplot
    scatter(x, y)
    scatter!(2x, 2y, 3y)
    el1 = gca().drawings[1]
    el2 = gca().drawings[2]
    @test el1.linestyle[1].lstyle == -1
    @test el1.markerstyle[1].marker == "circle"
    @test el2.linestyle[1].lstyle == -1
    @test el2.linestyle[2].lstyle == -1
    @test el2.markerstyle[1].marker == "circle"
    @test el2.markerstyle[2].marker == "circle"

    # FILL2D
    erase!(gcf())
    gcf().transparency = true
    x = 1:5
    y1 = exp.(x)
    y2 = sin.(x)
    fill_between(x, y1, y2, alpha=0.5)
    fill_between!(x, 0, y2, color="red", alpha=0.5)
    fill_between!(x, y1, 0)
    el1 = gca().drawings[1]
    el2 = gca().drawings[2]
    el3 = gca().drawings[3]
    @test el1.xy1y2 == hcat(x, y1, y2)
    @test el2.fillstyle.fill == RGBA{Float64}(1.0,0.0,0.0,0.5)
    @test el2.xy1y2 == hcat(x, 0*y2, y2)
    @test el3.xy1y2 == hcat(x, y1, 0*y1)

    cla()
    fill_between(x, 1, 2)
    el = gca().drawings[1]
    @test el.xy1y2 == G.fl(hcat(x, zero(x).+1, zero(x).+2))

    # HIST2D
    erase!(gcf())
    x = rand(Float32, 10)
    hist(x)
    @test gca().drawings[1].x == x

    # BAR
    cla()
    bar(x)
    y = rand(Float32, 10, 3)
    @test gca().drawings[1].xy == hcat(1:length(x), x)
    bar(x, x, x)
    @test gca().drawings[1].xy == hcat(x, x, x)
    bar(x, y)
    @test gca().drawings[1].xy == hcat(x, y)
    bar!(x, x, x)
    @test gca().drawings[2].xy == hcat(x, x, x)
end

@testset "▶ set_prop/drawing            " begin
    f = Figure()
    x, y = 1:2, exp.(1:2)
    plot(x, y, label="blah")
    @test gca().drawings[1].label == ["blah"]
    legend(pos="top-left")
    @test gca().legend.position == "tl"
    @test_throws GPlot.OptionValueError legend(pos="blah")

    hist(y, bins=2, norm="pdf")
    @test gca().drawings[1].bins == 2
    @test gca().drawings[1].scaling == "pdf"
    @test_throws GPlot.OptionValueError hist(y, norm="blah")
    hist(y, horiz=true)
    @test gca().drawings[1].horiz

    x1 = 1:5
    y1 = exp.(x1)
    y2 = sin.(x1)
    fill_between(x1, y1, y2, min=0, max=6)
    @test gca().drawings[1].xmin == 0.0
    @test gca().drawings[1].xmax == 6.0

    bar(x1, y1, y1+y2, stacked=true)
    @test gca().drawings[1].stacked
end

@testset "▶ apply_gle/drawing           " begin
    g = G.GLE()
    f = G.Figure();
    G.add_axes2d!()

    # Scatter2D (see also apply_linestyle)
    plot([1, 2], exp.([1, 2]), lwidth=2.0, label="line")
    legend()
    G.apply_axes!(g, f.axes[1], f.id); s = String(take!(g))
    isin(s, "data")
    isin(s, "d1=c1,c2")
    isin(s, "d1 line lwidth 2.0")
    isin(s, "begin key")
    isin(s, "compact")
    isin(s, "text \"line\" line lwidth 2.0")
    isin(s, "end key")

    clf()
    scatter([1, 2], exp.([1, 2]), color="blue")
    G.apply_axes!(g, f.axes[1], f.id); s = String(take!(g))
    isin(s, "d1=c1,c2")
    isin(s, "d1 marker circle color rgba(0.0,0.0,1.0,1.0)")

    # FILL2D
    clf()
    fill_between([1, 2], 1, 2)
    G.apply_axes!(g, f.axes[1], f.id); s = String(take!(g))
    isin(s, "d1=c1,c2 d2=c1,c3")
    isin(s, "fill d1,d2 color rgba(0.392,0.584,0.929,1.0)")

    # HIST2D
    clf()
    x = [0.1, 0.1, 0.2, 0.1, 0.3, 0.5, 0.7, 0.2, 0.1]
    hist(x, norm="pdf", fcol="blue", ecol="red")
    s = G.assemble_figure(gcf(), debug=true)
    isin(s, "_0.0_0.0_d1.csv")
    isin(s, "let d2 = hist d1 from $(minimum(x)) to $(maximum(x)) bins 9")
    isin(s, "let d2 = d2*1.666")
    isin(s, "bar d2 width 0.066")
    isin(s, "color rgba(1.0,0.0,0.0,1.0) fill rgba(0.0,0.0,1.0,1.0)")

    # BAR2D
    clf()
    x  = [1, 2, 3, 4, 5]
    y  = [3, 3, 4, 4, 3]
    y2 = [5, 5, 6, 6, 5]
    bar(x, y, y2, stacked=true)
    s = G.assemble_figure(gcf(), debug=true)
    isin(s, "bar d1")
    isin(s, "bar d2 from d1")
end
