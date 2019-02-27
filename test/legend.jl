@testset "▶ types/legend                " begin
    # LEGEND
    l = G.Legend()
    @test isnothing(l.position)
    @test l.textstyle isa G.TextStyle
    @test l.offset == (0.0,0.0)
    @test isnothing(l.bgcolor)
    @test isnothing(l.margins)
    @test !l.nobox
    @test !l.off
end

@testset "▶ /legend                     " begin
    f = Figure()
    erase!(f)
    legend(position="top-left")
    @test f.axes[1].legend.position == "tl"
    legend(position="bottom-right")
    @test f.axes[1].legend.position == "br"
end

@testset "▶ set_prop/legend             " begin
    # Legend
    cla()
    line([0,0],[1,1],label="line")
    legend(nobox=true, margins=(1.0,1.0), offset=(.5,.5))
    @test gca().legend.nobox
    @test gca().legend.margins == (1.0,1.0)
    @test gca().legend.offset == (0.5,0.5)
end

@testset "▶ apply_gle/legend            " begin

end
