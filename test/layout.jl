@testset "▶ /layout                     " begin
    # subplot(abc)
    f = Figure()
    subplot(222)
    @test length(f.axes) == 4
    @test gca() == f.axes[2]
    @test_throws ArgumentError subplot(10010)

    # subplot(a, b, c)
    @test_throws ArgumentError subplot(10, 1, 1)
    @test_throws ArgumentError subplot(1, 10, 1)
    @test_throws ArgumentError subplot(2, 2, 10)
    @test_throws ArgumentError subplot(2, 3, 5)

    # layout
    clf()
    @test isempty(f.axes)
    W, H = gcf().size
    layout(f, [0.1 0.1 0.3 0.3;
               0.1 0.5 0.3 0.3])
    @test length(f.axes) == 2
    @test f.axes[1].origin == (0.1W, 0.1H)
    @test f.axes[2].origin == (0.1W, 0.5H)
    @test f.axes[1].size == (0.3W, 0.3H)
    @test f.axes[2].size == (0.3W, 0.3H)

    @test_throws ArgumentError layout(f, [0.1 0.1 0.3 0.3 0.0; 0.1 0.5 0.3 0.3 0.0])
    @test_throws ArgumentError layout(f, [0.1 5.1 0.3 0.3 0.0; 0.1 0.5 0.3 0.3 0.0])
end
