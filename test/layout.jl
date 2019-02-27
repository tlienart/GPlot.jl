@testset "▶ /layout                     " begin
    # subplot(abc)
    f = Figure()
    subplot(222)
    @test length(f.axes) == 4
    @test gca() == f.axes[2]
    @test_throws AssertionError subplot(10010)

    # subplot(a, b, c)
    @test_throws AssertionError subplot(10, 1, 1)
    @test_throws AssertionError subplot(1, 10, 1)
    @test_throws AssertionError subplot(2, 2, 10)
    @test_throws AssertionError subplot(2, 3, 5)

    W, H = f.size
    @test f.axes[1].origin == (0.15/2*W, (1-0.85/2+0.15/2)*H)
    @test f.axes[2].origin == ((0.15/2+0.85/2)*W, (1-0.85/2+0.15/2)*H)
    @test f.axes[3].origin == (0.15/2*W, (1-0.85+0.15/2)*H)
    @test f.axes[4].origin == ((0.15/2+0.85/2)*W, (1-0.85+0.15/2)*H)
    for i ∈ 1:4
        @test f.axes[i].size == ((0.85/2-0.15/2)W, (0.85/2-0.15/2)H)
    end

    # layout
    clf()
    @test isempty(f.axes)
    layout(f, [0.1 0.1 0.3 0.3;
                0.1 0.5 0.3 0.3])
    @test length(f.axes) == 2
    @test f.axes[1].origin == (0.1W, 0.1H)
    @test f.axes[2].origin == (0.1W, 0.5H)
    @test f.axes[1].size == (0.3W, 0.3H)
    @test f.axes[2].size == (0.3W, 0.3H)

    @test_throws AssertionError layout(f, [0.1 0.1 0.3 0.3 0.0; 0.1 0.5 0.3 0.3 0.0])
    @test_throws AssertionError layout(f, [0.1 5.1 0.3 0.3 0.0; 0.1 0.5 0.3 0.3 0.0])
end
