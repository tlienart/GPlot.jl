@testset "Style -- types/style          " begin
    t = G.TextStyle()
    @test isnothing(t.font)
    @test isnothing(t.hei)
    @test isnothing(t.color)
    t = G.TextStyle(font="psh", hei=0.5, color=colorant"red")
    @test t.font == "psh"
    @test t.hei == 0.5
    @test t.color == colorant"red"

    l = G.LineStyle()
    @test isnothing(l.lstyle)
    @test isnothing(l.lwidth)
    @test isnothing(l.smooth)
    @test isnothing(l.color)
    l = G.LineStyle(lstyle=1, lwidth=0.1, smooth=true, color=colorant"red")
    @test l.lstyle == 1
    @test l.lwidth == 0.1
    @test l.smooth
    @test l.color == colorant"red"

    m = G.MarkerStyle()
    @test isnothing(m.marker)
    @test isnothing(m.msize)
    @test isnothing(m.color)
    m = G.MarkerStyle(marker="o", msize=1.5, color=colorant"red")
    @test m.marker == "o"
    @test m.msize == 1.5
    @test m.color == colorant"red"

    b = G.BarStyle()
    @test isnothing(b.color)
    @test isnothing(b.fill)
    b = G.BarStyle(color=colorant"red", fill=colorant"blue")
    b.color == colorant"red"
    b.fill == colorant"blue"

    f = G.FillStyle()
    @test f.color == colorant"cornflowerblue"
    f = G.FillStyle(color=RGBA(0.1,0.2,0.3,0.4))
    @test f.color == RGBA{Float64}(0.1,0.2,0.3,0.4)
end
