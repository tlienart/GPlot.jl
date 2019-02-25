@testset "▶ /object                     " begin
    f = Figure()
    text("blah", (0,0))
    @test gca().objects[1].anchor == (0.0,0.0)
    @test gca().objects[1].text == "blah"
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
