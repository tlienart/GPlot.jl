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
end

@testset "▶ apply_gle/object            " begin
    f = Figure()
    text("blah", (0,0))
    s = G.assemble_figure(f, debug=true)
    isin(s, "\ngsave")
    isin(s, "\nset just cc")
    isin(s, "\namove xg(0.0) yg(0.0)")
    isin(s, "\nwrite \"blah\"")
    isin(s, "\ngrestore")
end
