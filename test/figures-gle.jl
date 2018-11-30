
@testset "Figure - constructors         " begin
    # no name, base one
    f  = Figure()
    @test f.id == "_fig_"
    @test f.g isa GPlot.Backend
    @test isempty(f)
    @test gcf() == f
    @test gca() === nothing
    @test f.size == (12, 9)
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

    # add axes and check isempty
    @test isempty(f3)
    G.add_axes2d!()
    @test !isempty(f3)

    G.erase!(f3)
    @test isempty(f3)
end


@testset "Figure - set properties       " begin
    f = Figure(size=(5, 7), tex=true, texscale="fixed", alpha=true, transparency=true, preamble=tex"\usepackage{amssymb}")

    @test f.size == (5, 7)
    @test f.texlabels == true
    @test f.texscale == "fixed"
    @test f.transparency == true
    @test f.texpreamble == t"\usepackage{amssymb}"

    # when things go wrong, specifics for figure
    @test_throws G.OptionValueError Figure(tex=0)
    @test_throws G.UnknownOptionError Figure(something=5)
    @test_throws G.OptionValueError Figure(texscale="not-fixed")
end
