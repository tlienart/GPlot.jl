@testset "▶ /init                       " begin
    println("testing init... (re-warming)")
    G.__init__()
    @test G.GP_ENV["VERBOSE"]
    @test isdir(G.GP_ENV["TMP_PATH"])
    @test G.GP_ENV["DEL_INTERM"]
    @test !G.GP_ENV["SHOW_GSERR"]
    @test G.GP_ENV["WARMUP"]

    @test G.GP_ENV["BACKEND"] <: G.GLE

    # there should be nothing left from init
    @test isempty(G.GP_ENV["ALLFIGS"])
    @test isnothing(G.GP_ENV["CURFIG"])
    @test isnothing(G.GP_ENV["CURAXES"])
end
