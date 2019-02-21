@testset "▶ /render                     " begin
    if G.GP_ENV["HAS_BACKEND"]
        #
        # SAVEFIG
        #
        tmpdir = mktempdir()
        # - empty figure
        f = Figure("fig1", reset=true)
        # - base call
        plot(randn(10))
        @test savefig("figsave1", path=tmpdir) == joinpath(tmpdir, "figsave1.png")
        @test isfile(joinpath(tmpdir, "figsave1.png"))
    end
    #
    # PREVIEWFIG (NOTE, in a test environment this will error because not Juno/IJulia)
    #
    # pf = preview()
    # @test pf.fig.id == f.id
    # @test pf.fname == joinpath(G.GP_ENV["TMP_PATH"], "__PREVIEW__.png")
    # rf = render()
    # @test rf.fig.id == f.id
    # @test rf.fname == joinpath(G.GP_ENV["TMP_PATH"], "__PREVIEW__.png")
    #
    # CLEANUP
    #
    clf()
    plot(randn(10))
    G.assemble_figure(gcf())
    @test isfile(joinpath(G.GP_ENV["TMP_PATH"], gcf().id * ".gle"))
    G.cleanup(gcf())
    @test !isfile(joinpath(G.GP_ENV["TMP_PATH"], gcf().id * ".gle"))
end
