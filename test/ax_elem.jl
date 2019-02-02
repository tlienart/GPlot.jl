@testset "Axis Elems -- types/ax_elem   " begin
    # TITLE
    t = GPlot.Title(text="title")
    @test t.text == "title"
    @test isnothing(t.textstyle.font)
    @test isnothing(t.textstyle.hei)
    @test isnothing(t.textstyle.color)
    @test isnothing(t.prefix)
    @test isnothing(t.dist)

    t = GPlot.Title(text="title", textstyle=GPlot.TextStyle(font="psh"),
                    prefix="x", dist=0.3)
    @test t.textstyle.font == "psh"
    @test t.prefix == "x"
    @test t.dist == 0.3

    # LEGEND
    l = GPlot.Legend()
    @test isnothing(l.position)
    @test isnothing(l.hei)
    l.position = "tl"
    l.hei = 0.3
    @test l.position == "tl"
    @test l.hei == 0.3

    # TICKS AND TICKSLABELS
    t = GPlot.Ticks("x")
    @test t.prefix == "x"
    @test isnothing(t.labels.names)
    @test isnothing(t.labels.off)
    @test isnothing(t.labels.angle)
    @test isnothing(t.labels.format)
    @test isnothing(t.labels.shift)
    @test isnothing(t.labels.dist)
    @test isnothing(t.linestyle.color)
    @test isnothing(t.places)
    @test isnothing(t.off)
    @test isnothing(t.length)
    @test isnothing(t.symticks)
end

@testset "Axis Elems -- /ax_elem        " begin
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
    @test isnothing(f.axes[1].x2axis.ticks.labels.names)
    @test isnothing(f.axes[1].y2axis.ticks.labels.names)
    xticks!([1.0, 2.3])
    @test f.axes[1].xaxis.ticks.places == [1.0, 2.3]
    @test isnothing(f.axes[1].xaxis.ticks.labels.names)

    # legend
    erase!(f)
    legend(position="top-left")
    @test f.axes[1].legend.position == "tl"
    legend!(position="bottom-right")
    @test f.axes[1].legend.position == "br"
end

@testset "Axis Elems -- set_prop/ax_elem" begin
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
