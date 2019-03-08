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
    data = randn(5, 5)
    h = (heatmap(data)).drawing
    @test h.zmin == minimum(data)
    @test h.zmax == maximum(data)
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
        X = [0.214554    0.204954  -0.106862;
             -1.96864     0.441998   0.862069;
              0.355096    1.34095    0.94196;
             -1.04456    -0.159273   0.542868;
              0.698542    0.68037    0.130701;
              0.136469    0.878217   1.19285;
              0.811287   -0.526169   0.0629558;
              0.498855    0.833732   0.668236;
             -0.0956764   1.04196    0.548804;
             -1.09126     1.27123   -1.58358;
              5.0        -5.0        6.0  ] # forces outlier

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

        X[1,1] = NaN
        @test_throws ArgumentError boxplot(X)

    end # > BOXPLOT

    begin # HEATMAP
        clf()
        X = randn(5, 5)
        heatmap(X)
        s = G.assemble_figure(gcf(), debug=true)
        isin(s, "d1=c0,c1 d2=c0,c2 d3=c0,c3 d4=c0,c4 d5=c0,c5")
        isin(s, "draw hm_")
        for i ∈ 1:5
            isin(s, " $i d$i 0.2 0.2")
        end
        @test_throws ArgumentError heatmap_ticks("xxx")

        cla()
        @test_throws ArgumentError heatmap_ticks("x") # empty

    end # > HEATMAP
end
