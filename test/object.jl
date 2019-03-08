@testset "▶ /object                     " begin
    f = Figure()
    text("blah", (0,0))
    @test gca().objects[1].anchor == (0.0,0.0)
    @test gca().objects[1].text == "blah"

    # vline, hline
    clo()
    hline(0.5; lw=0.1)
    vline(0.2; col="red")
    @test gca().objects[1] isa G.StraightLine2D
    @test gca().objects[1].anchor == 0.5
    @test gca().objects[1].horiz == true
    @test gca().objects[1].linestyle.lwidth == 0.1
    @test gca().objects[2].anchor == 0.2
    @test gca().objects[2].linestyle.color == c"red"
    @test gca().objects[2].horiz == false

    # box
    clo()
    box((0.5, 0.2), (0.0,0.0); col="red", fill="blue")
    @test gca().objects[1] isa G.Box2D
    @test gca().objects[1].anchor == (0.0,0.0)
    @test gca().objects[1].size == (0.5,0.2)
    @test gca().objects[1].fillstyle.fill == c"blue"
    @test gca().objects[1].linestyle.color == c"red"
    @test gca().objects[1].nobox == true

    # colorbar
    clo()
    colorbar(0, 1, [c"blue", c"red", c"green"])
    @test gca().objects[1] isa G.Colorbar
    @test gca().objects[1].zmin == 0.0
    @test gca().objects[1].zmax == 1.0
    @test gca().objects[1].cmap == [c"blue", c"red", c"green"]
    @test gca().objects[1].ticks.places == collect(range(0,stop=1,length=5)[2:end-1])
    @test isnothing(gca().objects[1].size)
    @test gca().objects[1].pixels == 100
    @test gca().objects[1].nobox == true
    @test gca().objects[1].position == "right"
    @test gca().objects[1].offset == (0.3,0.0)

    # clf()
    # X = randn(2,2)
    # h = heatmap(X)
    # colorbar(h)
    # @test gca().objects[1].zmin == minimum(X)
    # @test gca().objects[1].zmax == maximum(X)
end

@testset "▶ apply_gle/object            " begin
    f = Figure()

    begin # TEXT
        clf()
        text("blah", (0,0))
        s = G.assemble_figure(f, debug=true)
        isin(s, "\ngsave")
        isin(s, "\nset just cc")
        isin(s, "\namove xg(0.0) yg(0.0)")
        isin(s, "\nwrite \"blah\"")
        isin(s, "\ngrestore")
    end

    begin # STRAIGHTLINE
        clf()
        plot([0, 1],[0, 1])
        hline(0.1; col="red")
        vline(0.5; lw=0.5)
        s = G.assemble_figure(f, debug=true)
        isin(s, "d1 line color") # plot
        # plot horizontal line
        isin(s, "gsave")
        isin(s, "set color rgba(1.0,0.0,0.0,1.0)")
        isin(s, "amove xg(xgmin) yg(0.1)")
        isin(s, "aline xg(xgmax) yg(0.1)")
        isin(s, "grestore")
        isin(s, "set lwidth 0.5")
        isin(s, "amove xg(0.5) yg(ygmin)")
        isin(s, "aline xg(0.5) yg(ygmax)")
    end

    begin #
    end
end
