@testset "Figure -- /figure             " begin
    # CONSTRUCTORS
    # --> nothing
    f  = Figure()
    @test f.id == "_fig_"
    @test f.g isa GPlot.Backend
    @test f.axes isa Vector
    @test eltype(f.axes) == GPlot.Axes{GPlot.GLE}
    @test f.size == (12., 9.)
    @test f.textstyle.hei == 0.35 # default
    @test isnothing(f.textstyle.font)
    @test isnothing(f.textstyle.color)
    @test isnothing(f.texlabels)
    @test isnothing(f.texscale)
    @test isnothing(f.texpreamble)
    @test isnothing(f.transparency)
    @test isempty(f)
    @test gcf() == f
    @test gca() === nothing

    # --> name
    f2 = Figure("test")
    @test f2.id == "test"
    @test gcf() == f2
    @test gca() === nothing
    @test GPlot.GP_ENV["ALLFIGS"]["test"] == f2

    # --> recuperate via id
    f3 = Figure("test")
    @test f2 === f3

    # add axes and check isempty
    @test isempty(f3)
    GPlot.add_axes2d!()
    @test !isempty(f3)

    GPlot.erase!(f3)
    @test isempty(f3)
end


@testset "Figure -- set_prop/figure     " begin
    f = Figure(size=(5, 7), tex=true, texscale="fixed",
               alpha=true, transparency=true,
               preamble=tex"\usepackage{amssymb}",
               font="helvetica", fontsize=11)

    @test f.size == (5., 7.)
    @test f.texlabels == true
    @test f.texscale == "fixed"
    @test f.transparency == true
    @test f.texpreamble == t"\usepackage{amssymb}"
    @test f.textstyle.font == "psh"
    @test f.textstyle.hei  == 11 * GPlot.PT_TO_CM

    # when things go wrong, specifics for figure
    @test_throws MethodError Figure(tex=0)
    @test_throws GPlot.UnknownOptionError Figure(something=5)
    @test_throws GPlot.OptionValueError Figure(texscale="not-fixed")
end
