@testset "▶ types/ax_elem               " begin
    # TITLE
    t = GPlot.Title(text="title")
    @test t.text == "title"
    @test isnothing(t.textstyle.font)
    @test isnothing(t.textstyle.hei)
    @test isnothing(t.textstyle.color)
    @test isnothing(t.dist)

    t = GPlot.Title(text="title", textstyle=GPlot.TextStyle(font="psh"), dist=0.3)
    @test t.textstyle.font == "psh"
    @test t.dist == 0.3

    # LEGEND
    l = GPlot.Legend()
    @test isnothing(l.position)
    @test l.textstyle isa G.TextStyle
    @test l.offset == (0.0,0.0)
    @test isnothing(l.bgcolor)
    @test isnothing(l.margins)
    @test !l.nobox
    @test !l.off

    # TICKS AND TICKSLABELS
    t = GPlot.Ticks()
    @test t.labels.names == String[]
    @test t.labels.off == false
    @test isnothing(t.labels.angle)
    @test isnothing(t.labels.format)
    @test isnothing(t.labels.shift)
    @test isnothing(t.labels.dist)
    @test isnothing(t.linestyle.color)
    @test t.places == Float64[]
    @test t.off == false
    @test isnothing(t.length)
    @test t.symticks == false
    @test t.grid == false
end

@testset "▶ /ax_elem                    " begin
    f = Figure()
    # titles and co
    title("blah"); erase!(f)
    xtitle("blah"); erase!(f)
    x2title("blah"); erase!(f)
    ytitle("blah"); erase!(f)
    y2title("blah")
    @test f.axes[1].y2axis.title.text  == "blah"
    x2title!("blih", font="psh")
    @test f.axes[1].x2axis.title.textstyle.font == "psh"
    x2title!("blah")
    @test f.axes[1].x2axis.title.textstyle.font == "psh"
    @test f.axes[1].x2axis.title.text == "blah"
    y2title("hello")
    @test f.axes[1].y2axis.title.text == "hello"
    erase!(f)
    xtitle!("hello")
    erase!(f)
    title("blah", font="psh"); title!("blih")
    @test f.axes[1].title.text == "blih"
    @test f.axes[1].title.textstyle.font == "psh"
    ytitle("blah", font="psh"); ytitle!("blih")
    @test f.axes[1].yaxis.title.text == "blih"
    @test f.axes[1].yaxis.title.textstyle.font == "psh"
    y2title("blah", font="psh"); y2title!("blih")
    @test f.axes[1].y2axis.title.text == "blih"
    @test f.axes[1].y2axis.title.textstyle.font == "psh"

    # ticks and ticklabels
    erase!(f)
    xticks([1, 2], ["A", "B"]); x2ticks([3, 4])
    yticks([1, 2], ["A", "B"]); y2ticks([3, 4])
    @test f.axes[1].xaxis.ticks.places == [1., 2.]
    @test f.axes[1].yaxis.ticks.places == [1., 2.]
    @test f.axes[1].x2axis.ticks.places == [3., 4.]
    @test f.axes[1].y2axis.ticks.places == [3., 4.]
    @test f.axes[1].xaxis.ticks.labels.names == ["A", "B"]
    @test f.axes[1].yaxis.ticks.labels.names == ["A", "B"]
    @test isempty(f.axes[1].x2axis.ticks.labels.names)
    @test isempty(f.axes[1].y2axis.ticks.labels.names)
    xticks!([1.0, 2.3])
    @test f.axes[1].xaxis.ticks.places == [1.0, 2.3]
    @test isempty(f.axes[1].xaxis.ticks.labels.names)

    @test_throws ArgumentError xticks([1, 2], ["A", "B", "C"])

    x2ticks!([3, 5])
    @test f.axes[1].x2axis.ticks.places == [3., 5.]
    yticks!([3, 5])
    @test f.axes[1].yaxis.ticks.places == [3., 5.]
    y2ticks!([3, 5])
    @test f.axes[1].y2axis.ticks.places == [3., 5.]

    # -- empty
    cla()
    xticks(color="blue")
    @test gca().xaxis.ticks.places == Float64[]
    @test gca().xaxis.ticks.labels.names == String[]
    @test gca().xaxis.ticks.labels.textstyle.color == colorant"blue"

    @test_throws ArgumentError xticks(Float64[], ["blah", "blah"])

    # grid
    cla()
    grid(axis=["x", "y"], lstyle="--", color="lightgray")
    @test gca().xaxis.ticks.linestyle.lstyle == 9
    @test gca().yaxis.ticks.linestyle.lstyle == 9
    @test gca().xaxis.ticks.linestyle.color == colorant"lightgray"
    @test gca().yaxis.ticks.linestyle.color == colorant"lightgray"

    # legend
    erase!(f)
    legend(position="top-left")
    @test f.axes[1].legend.position == "tl"
    legend!(position="bottom-right")
    @test f.axes[1].legend.position == "br"

    x2ticks("off")
    @test gca().x2axis.ticks.off
    @test gca().x2axis.ticks.labels.off

    # more ax elem
    cla()
    xaxis("off")
    @test gca().xaxis.off
    xaxis("on")
    @test !gca().xaxis.off

end

@testset "▶ set_prop/ax_elem            " begin
    f = Figure()
    # Title
    title("blah", dist=1); @test f.axes[1].title.dist == 1.0
    @test_throws GPlot.OptionValueError title("b", dist=-1)
    @test_throws GPlot.UnknownOptionError  title("b", blah=5)
    # Ticks
    y2ticks([1, 2], off=true); @test f.axes[1].y2axis.ticks.off
    @test_throws GPlot.NotImplementedError yticks([1, 2], length=0.5)
    @test_throws GPlot.NotImplementedError y2ticks([1, 2], symticks=true)
    erase!(f)
    x2ticks([1, 2], ["a", "b"], tickscolor="blue")
    @test f.axes[1].x2axis.ticks.linestyle.color == colorant"blue"
    y2ticks([1, 2], ["a", "b"], angle=45)
    @test  f.axes[1].y2axis.ticks.labels.angle == 45
    @test_throws GPlot.NotImplementedError yticks([1, 2], format="something")
    x2ticks([1, 2], shift=0.1)
    @test f.axes[1].x2axis.ticks.labels.shift == 0.1
    yticks([1, 2], off=true)
    @test f.axes[1].yaxis.ticks.off == true
    yticks([1, 2], ["a", "b"], hidelabels=true)
    @test f.axes[1].yaxis.ticks.labels.off == true
end

@testset "▶ apply_gle/ax_elem           " begin
    g = G.GLE()
    f = G.Figure();
    G.add_axes2d!()

    # title (see also apply_textstyle)
    erase!(f)
    title("title")
    xlabel("xlabel", dist=0.5)
    G.apply_axes!(g, f.axes[1], f.id); s = String(take!(g))
    isin(s, "title \"title\"")
    isin(s, "xtitle \"xlabel\" dist 0.5")

    # ticks (see also apply_linestyle, apply_tickslabels)
    erase!(f)
    y2ticks([1, 2])
    xticks([1, 2], off=true)
    G.apply_axes!(g, f.axes[1], f.id); s = String(take!(g))
    isin(s, "y2places 1.0 2.0")
    isin(s, "xticks off")
    # XXX test symticks, length

    # tickslabels (see also apply_textstyle)
    erase!(f)
    x2ticks([1, 2], ["a", "b"], dist=0.5, angle=45, shift=1)
    G.apply_axes!(g, f.axes[1], f.id); s = String(take!(g))
    isin(s, "x2places 1.0 2.0")
    isin(s, "x2names \"a\" \"b\"")
    isin(s, "x2labels  dist 0.5")
    isin(s, "x2axis angle 45.0 shift 1.0")
end
