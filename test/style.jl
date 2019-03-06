@testset "▶ types/style                 " begin
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
    @test b.fill == colorant"white"
    b = G.BarStyle(color=colorant"red", fill=colorant"blue")
    @test b.color == colorant"red"
    @test b.fill == colorant"blue"

    f = G.FillStyle()
    @test f.fill == colorant"cornflowerblue"
    f = G.FillStyle(fill=RGBA(0.1,0.2,0.3,0.4))
    @test f.fill == RGBA{Float64}(0.1,0.2,0.3,0.4)
end

@testset "▶ set_prop/style              " begin
    # color
    x, y = 1:2, exp.(1:2)
    plot(x, y, col="indianred", mcol="blue")
    @test gca().drawings[1].linestyles[1].color == colorant"indianred"
    @test gca().drawings[1].markerstyles[1].color == colorant"blue"
    hist(y, fill="indianred", ecol="blue")
    @test gca().drawings[1].barstyle.color == colorant"blue"
    @test gca().drawings[1].barstyle.fill == colorant"indianred"
    fill_between(x, y, 2y, fill="blue")
    @test gca().drawings[1].fillstyle.fill == colorant"blue"
    xticks([1,2],["a","b"],tickscolor="blue", col="red")
    @test gca().xaxis.ticks.linestyle.color == colorant"blue"
    @test gca().xaxis.ticks.labels.textstyle.color == colorant"red"
    title("blah", col="red")
    @test gca().title.textstyle.color == colorant"red"
    bar(x, y, 2y, ecols=["red", "blue"], fills=["blue", "red"])
    @test gca().drawings[1].barstyles[1].color == colorant"red"
    @test gca().drawings[1].barstyles[2].color == colorant"blue"
    @test gca().drawings[1].barstyles[1].fill == colorant"blue"
    @test gca().drawings[1].barstyles[2].fill == colorant"red"
    @test_throws DimensionMismatch bar(x, y, 2y, colors=["red"])

    f = Figure(transparency=true)
    hist(y, fill="indianred", alpha=0.5)
    @test gca().drawings[1].barstyle.fill.alpha == 0.502Colors.N0f8

    title("blah", font="roman", fontsize=0.3)
    @test gca().title.textstyle.font == "rm"
    @test gca().title.textstyle.hei == 0.3 * G.PT_TO_CM

    @test_throws G.OptionValueError title("blih", font="rzxd")
    @test_throws G.OptionValueError title("blih", fontsize=-1)

    plot(x, y, ls="--", lw=0.3)
    @test gca().drawings[1].linestyles[1].lstyle == 9
    @test gca().drawings[1].linestyles[1].lwidth == 0.3
    @test_throws G.OptionValueError plot(x, y, ls="blah")
    plot(x, y, ls=1)
    @test gca().drawings[1].linestyles[1].lstyle == 1
    @test_throws G.OptionValueError plot(x,y,lw=-1)
    plot(x, y, smooth=true)
    @test gca().drawings[1].linestyles[1].smooth = true
    plot(x, y, marker="o")
    @test gca().drawings[1].markerstyles[1].marker == "circle"
    @test_throws G.OptionValueError plot(x, y, marker="asidf")
    #XXX plot(x, y, marker="o", mcol="blue", msize=1.5)
    #XXX @test gca().drawings[1].markerstyle[1].color == colorant"blue"
    #XXX @test gca().drawings[1].markerstyle[1].msize == 1.5
    @test_throws G.OptionValueError plot(x, y, marker="square", msize=-2)

    f = Figure(bgcol="blue")
    @test f.bgcolor == colorant"blue"
    set(f, bgalpha=0.2)
    @test f.bgcolor == RGBA(0.0,0.0,1.0,0.2)

    cla()
    xticks([1, 2, 3], font="psh", fontsize=12)
    @test gca().xaxis.ticks.labels.textstyle.font == "psh"
    @test gca().xaxis.ticks.labels.textstyle.hei == 12 * G.PT_TO_CM

    cla()
    scatter(x, y, msize=0.5)
    @test gca().drawings[1].markerstyles[1].msize==0.5

    cla()
    bar([1, 2, 3], width=1.2)
    @test gca().drawings[1].bwidth==1.2
end

@testset "▶ apply_gle/style             " begin
    g = G.GLE()

    # textstyle
    ts = G.TextStyle(font="roman",hei=3.5,color=colorant"red")
    G.apply_textstyle!(g, ts); s = String(take!(g))
    isin(s, "font roman hei 3.5 color rgba(1.0,0.0,0.0,1.0)")
    ts = G.TextStyle()
    G.apply_textstyle!(g, ts); s = String(take!(g))
    @test s == ""

    # linestyle
    ls = G.LineStyle(lstyle=1, lwidth=0.1, smooth=true, color=colorant"red")
    G.apply_linestyle!(g, ls); s = String(take!(g))
    isin(s, "lstyle 1 lwidth 0.1 color rgba(1.0,0.0,0.0,1.0) smooth")
    ls = G.LineStyle()
    G.apply_linestyle!(g, ls); s = String(take!(g))
    @test s == ""

    # markerstyle
    ms = G.MarkerStyle(marker="circle", msize=0.5, color=colorant"red")
    G.apply_markerstyle!(g, ms); s = String(take!(g))
    isin(s, "circle msize 0.5 color rgba(1.0,0.0,0.0,1.0)")
    ms = G.MarkerStyle()
    G.apply_markerstyle!(g, ms); s = String(take!(g))
    @test s == ""
    ms = G.MarkerStyle(marker="circle", msize=0.5, color=colorant"red")
    G.apply_markerstyle!(g, ms, mcol=true); s = String(take!(g))
    @test s == "marker mk_circle_rgba_1_0_0_0_0_0_1_0_ 0.5 "

    # barstyle
    bs = G.BarStyle(color=colorant"red", fill=colorant"blue")
    G.apply_barstyle!(g, bs); s = String(take!(g))
    isin(s, "color rgba(1.0,0.0,0.0,1.0) fill rgba(0.0,0.0,1.0,1.0)")
    bs = G.BarStyle()
    G.apply_barstyle!(g, bs); s = String(take!(g))
    isin(s, "fill rgba(1.0,1.0,1.0,1.0)")

    bs1 = G.BarStyle(color=colorant"red", fill=colorant"blue")
    bs2 = G.BarStyle(color=colorant"blue", fill=colorant"red")
    G.apply_barstyles_nostack!(g, [bs1, bs2]); s = String(take!(g))
    isin(s, "color rgba(1.0,0.0,0.0,1.0),rgba(0.0,0.0,1.0,1.0) fill rgba(0.0,0.0,1.0,1.0),rgba(1.0,0.0,0.0,1.0)")
    bs0 = G.BarStyle()
    G.apply_barstyles_nostack!(g, [bs0]); s = String(take!(g))
    isin(s, "fill rgba(1.0,1.0,1.0,1.0)")
end
