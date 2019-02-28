@testset "▶ types/figure                " begin
    f = Figure()
    io = IOBuffer()
    Base.show(io, MIME("text/plain"), f)
    s = String(take!(io))
    @test all(split(s) .== split(raw"""
    GPlot.Figure{GLE}
        Name:          default ("_fig_")
        Size:          (12.0, 9.0)
        Bg. color:     white
        N. axes:       0
        LaTeX:         false
        Transparent:   false"""))
end

@testset "▶ /figure                     " begin
    # CONSTRUCTORS
    # --> nothing
    f  = Figure()
    @test f.id == "_fig_"
    @test f.g isa GPlot.Backend
    @test f.axes isa Vector
    @test eltype(f.axes) == GPlot.Axes{GPlot.GLE}
    @test f.size == (12., 9.)
    @test f.textstyle.hei == 0.35 # default
    @test f.textstyle.font == "texcmss"
    @test isnothing(f.textstyle.color)
    @test isnothing(f.texlabels)
    @test isnothing(f.texscale)
    @test isnothing(f.texpreamble)
    @test isnothing(f.transparency)
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
    @test isempty(f3.axes)
    GPlot.add_axes2d!()
    @test !isempty(f3.axes)

    GPlot.erase!(f3)
    @test isempty(f3.axes)

    GPlot.destroy(f3)
    @test "test" ∉ keys(GPlot.GP_ENV["ALLFIGS"])

    # Subroutine
    f = Figure()
    m = G.MarkerStyle("circle", 0.5, colorant"blue")
    G.add_sub_marker!(f, m)
    f.subroutines["marker_circle_rgba_0_0_0_0_1_0_1_0_"] == raw"""
    sub _marker_circle_rgba_0_0_0_0_1_0_1_0_ size mdata
        gsave
        set color rgba(0.0,0.0,1.0,1.0)
        marker circle 1
        grestore
    end sub
    define marker marker_circle_rgba_0_0_0_0_1_0_1_0_ _marker_circle_rgba_0_0_0_0_1_0_1_0_
    """
end


@testset "▶ set_prop/figure             " begin
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
