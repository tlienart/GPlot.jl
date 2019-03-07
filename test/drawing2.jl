@testset "▶ types/drawing2              " begin
    # Boxplot
    stats = randn(5, 3)
    bp = G.Boxplot(stats, 3)
    @test bp.stats == stats
    @test bp.nobj == 3
    @test length(bp.boxstyles) == 3
    @test bp.boxstyles[1] isa G.BoxplotStyle
    @test bp.horiz == false

    # Heatmap
    data = rand(Int, 3, 3)
    h = G.Heatmap(data=data)
    @test h.data == data
    @test h.cmap == colormap("RdBu", 10)
    @test h.cmiss == c"white"
    @test h.transpose == false
end

@testset "▶ /drawing2                   " begin
end

@testset "▶ set_prop/drawing2           " begin
end

@testset "▶ apply_gle/drawing2          " begin
end
