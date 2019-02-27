struct Foo
    x
    y
end

mutable struct Bar
    x::GPlot.Option{Int}
    y::GPlot.Option{Int}
    z::Bool
end

@testset "▶ /utils                      " begin
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

    @test GPlot.round3d(pi) == 3.142
    @test GPlot.col2str(colorant"red") == "rgba(1.0,0.0,0.0,1.0)"

    @test GPlot.vec2str([1,2,3]) == "1 2 3 "
    @test GPlot.vec2str(["a","b","c"]) == "\"a\" \"b\" \"c\" "
    @test GPlot.svec2str(["a","b","c"]) == "a,b,c"
    @test GPlot.svec2str(["a"]) == "a"
    @test GPlot.svec2str(("a$i" for i ∈ 1:3)) == "a1,a2,a3"

    @test t"\sin(x)+\cos(x)" == "\\sin(x)+\\cos(x)"
    _α = 5
    @test t"\sin(##_α x)" == "\\sin(5 x)"

    # FL
    @test G.fl(nothing) === nothing
    @test G.fl(missing) === missing
    @test G.fl(2) == 2.0

    # CSV_writer
    f, _ = mktemp()
    z = zip([missing, 1, Inf, 3, missing, NaN])
    G.csv_writer(f, z, true)
    ff = read(f, String)
    ff == "?\n1\n?\n3\n?\n?\n"
end

@testset "▶ /utils2                     " begin
    f = Figure("blah", reset=true)
    @test gcf().id == f.id
    @test gcf().size == f.size
    @test gca() === nothing

    m = G.MarkerStyle("circle", 0.5, colorant"blue")
    @test G.str(m) == "marker_circle_rgba_0_0_0_0_1_0_1_0_"

    set_palette([colorant"blue", colorant"red"])
    @test G.GP_ENV["PALETTE"] == [colorant"blue", colorant"red"]
    @test G.GP_ENV["SIZE_PALETTE"] == 2
end
