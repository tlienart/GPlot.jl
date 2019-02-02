struct Foo
    x
    y
end

mutable struct Bar
    x::GPlot.Option{Int}
    y::GPlot.Option{Int}
    z::Bool
end

@testset "Utils -- /utils               " begin
    g = GPlot.GLE()
    gp = GPlot.Gnuplot()
    @test typeof(g) <: GPlot.Backend
    @test typeof(gp) <: GPlot.Backend
    @test g.io isa IOBuffer
    @test gp.io isa IOBuffer

    "blah" |> g
    @test String(take!(g)) == "blah " # NOTE extra space
    "blih" |> (g, gp)
    @test String(take!(g)) == String(take!(gp)) == "blih "

    @test isnothing(nothing)
    @test GPlot.isdef(1)
    @test !GPlot.isdef(nothing)

    @test GPlot.isanydef(Foo(1, 2))
    @test GPlot.isanydef(Foo(1, nothing))
    @test !GPlot.isanydef(Foo(nothing, nothing))

    b = Bar(1, 2, true)
    GPlot.clear!(b)
    @test isnothing(b.x) && isnothing(b.y) && b.z

    @test GPlot.round3d(pi) == 3.142
    @test GPlot.col2str(colorant"red") == "rgba(1.0,0.0,0.0,1.0)"
    @test GPlot.try_parse_col("red") == colorant"red"
    @test_throws GPlot.OptionValueError GPlot.try_parse_col("redd")

    @test GPlot.vec2str([1,2,3]) == "1 2 3 "
    @test GPlot.vec2str(["a","b","c"]) == "\"a\" \"b\" \"c\" "
    @test GPlot.svec2str(["a","b","c"]) == "a,b,c"
    @test GPlot.svec2str(["a"]) == "a"
    @test GPlot.svec2str(("a$i" for i ∈ 1:3)) == "a1,a2,a3"

    @test t"\sin(x)+\cos(x)" == "\\sin(x)+\\cos(x)"
    _α = 5
    @test t"\sin(##_α x)" == "\\sin(5 x)"
end
