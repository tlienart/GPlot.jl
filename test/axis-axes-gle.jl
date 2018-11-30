@testset "Axes - containers             " begin
    a = G.Axes2D{G.GLE}()
    @test a isa G.Axes{G.GLE}
    @test a.drawings isa Vector{G.Drawing}
    @test isempty(a.drawings)
    @test !G.isdef(a.title)
    @test !G.isdef(a.size)
    @test !G.isdef(a.math)
    @test !G.isdef(a.legend)
end

@testset "Axis - containers             " begin
    a = G.Axes2D{G.GLE}()
    @test a.xaxis.prefix == "x"
    @test a.xaxis.ticks.prefix == "x"
end
