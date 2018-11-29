
@testset "Figure - constructors         " begin
    # no name, base one
    f  = Figure()
    @test f.id == "_fig_"
    @test f.g isa GPlot.Backend
    @test isempty(f)
    @test gcf() == f
    @test gca() === nothing
    @test f.size == (8., 6.)
    @test !isdef(f.texlabels)
    @test !isdef(f.texscale)
    @test !isdef(f.texpreamble)
    @test !isdef(f.transparency)

    # specific name
    f2 = Figure("test")
    @test f2.id == "test"

    # dictionary of figures
    @test gcf() == f2
    @test gca() === nothing
    @test G.GP_ALLFIGS["test"] == f2

    # recuperate via id
    f3 = Figure("test")
    @test f2 === f3
end
