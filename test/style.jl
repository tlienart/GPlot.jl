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

@testset "Style -- set_prop/style       " begin
    # color
    x, y = 1:2, exp.(1:2)
    plot(x, y, col="indianred")
    @test gca().drawings[1].linestyle.color == colorant"indianred"
    hist(y, fcol="indianred", ecol="blue")
    @test gca().drawings[1].barstyle.color == colorant"blue"
    @test gca().drawings[1].barstyle.fill == colorant"indianred"
    fill_between(x, y, 2y, fcol="blue")
    @test gca().drawings[1].fillstyle.color == colorant"blue"
    xticks([1,2],["a","b"],tickscolor="blue", col="red")
    @test gca().xaxis.ticks.linestyle.color == colorant"blue"
    @test gca().xaxis.ticks.labels.textstyle.color == colorant"red"
    title("blah", col="red")
    @test gca().title.textstyle.color == colorant"red"
    bar(x, y, 2y, colors=["red", "blue"], fcol=["blue", "red"])
    @test gca().drawings[1].barstyle[1].color == colorant"red"
    @test gca().drawings[1].barstyle[2].color == colorant"blue"
    @test gca().drawings[1].barstyle[1].fill == colorant"blue"
    @test gca().drawings[1].barstyle[2].fill == colorant"red"
    @test_throws AssertionError bar(x, y, 2y, colors=["red"])

    f = Figure(transparency=true)
    hist(y, fcol="indianred", alpha=0.5)
    @test gca().drawings[1].barstyle.fill.alpha == 0.5

    title("blah", font="roman", fontsize=0.3)
    @test gca().title.textstyle.font == "rm"
    @test gca().title.textstyle.hei == 0.3 * G.PT_TO_CM

    @test_throws G.OptionValueError title("blih", font="rzxd")
    @test_throws G.OptionValueError title("blih", fontsize=-1)

    plot(x, y, ls="--", lw=0.3)
    @test gca().drawings[1].linestyle.lstyle == 9
    @test gca().drawings[1].linestyle.lwidth == 0.3
    @test_throws G.OptionValueError plot(x, y, ls="blah")
    plot(x, y, ls=1)
    @test gca().drawings[1].linestyle.lstyle == 1
    @test_throws G.OptionValueError plot(x,y,lw=-1)
    plot(x, y, smooth=true)
    @test gca().drawings[1].linestyle.smooth = true
    plot(x, y, marker="o")
    @test gca().drawings[1].markerstyle.marker == "circle"
    @test_throws G.OptionValueError plot(x, y, marker="asidf")
    plot(x, y, marker="o", mcol="blue", msize=1.5)
    @test gca().drawings[1].markerstyle.color == colorant"blue"
    @test gca().drawings[1].markerstyle.msize == 1.5
    @test_throws G.OptionValueError plot(x, y, marker="square", msize=-2)
end
