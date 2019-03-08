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
    # -------
    # BOXPLOT
    # -------
    f = Figure()

    # error on empty
    @test_throws ArgumentError boxplot()

    nobj = 3
    X = randn(20, nobj)
    q00, q25, q50, q75, q100 = quantile(X[:,1], [.0,.25,.5,.75,1.0])
    iqr = q75-q25
    mean = Statistics.mean(X[:,1])
    wlow = q25 - 1.5*iqr
    whigh = q75 + 1.5*iqr
    dhb = boxplot(X)
    @test dhb.drawing isa G.Boxplot
    @test dhb.drawing.nobj == nobj
    @test dhb.drawing.stats[1, :] == [wlow,q25,q50,q75,whigh,mean]
    @test gca().xaxis.min == 0
    @test gca().xaxis.max == nobj+1
    @test gca().xaxis.ticks.places == collect(1:nobj)
    @test gca().yaxis.min == minimum(X) - 0.5abs(minimum(X))
    @test gca().yaxis.max == maximum(X) + 0.5abs(maximum(X))

    dhb = boxplot(X, whiskers=Inf, horiz=true)
    @test dhb.drawing.stats[1, :] == [q00,q25,q50,q75,q100,mean]

end

@testset "▶ set_prop/drawing2           " begin
end

@testset "▶ apply_gle/drawing2          " begin
    f = Figure()
    begin # BOXPLOT
        clf()
        Random.seed!(0)
        X = vcat(randn(10, 3), [5 -5 3]) # force outliers
        boxplot(X; box_lw=0.1, box_cols="red", med_ls="--", med_cols="seagreen",
                   mean_show=true, mean_markers="diamond", out_show=true,
                   out_markers="+", out_msize=0.2, out_mcols="red")
        s = G.assemble_figure(gcf(), debug=true)
        for i ∈ 1:3
            q25,q50,q75 = quantile(X[:,i], [0.25,0.50,0.75])
            iqr = q75-q25
            μ = sum(X[:,i])/length(X[:,i])
            iqr15 = 1.5iqr
            isin(s, "draw bp_vert $i $(q25-iqr15) $q25 $q50 $q75 $(q75+iqr15) $μ")
            isin(s, "0.6 0.3 1 0.1 \"rgba(1.0,0.0,0.0,1.0)\"") # box
            isin(s, "9 0.0 \"rgba(0.18,0.545,0.341,1.0)\" 1 diamond") # med,mean
        end
        # outliers
        for i ∈ 4:6
            isin(s, "d$i marker plus msize 0.2 color rgba(1.0,0.0,0.0,1.0)")
        end
    end

    begin # HEATMAP
    end
end
