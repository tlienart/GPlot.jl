function __init__()
    # default backend for now
    test_gle()
    GP_ENV["BACKEND"] = GLE

    # WARMUP PHASE
    f = Figure("___")
    x = [1, 2]
    y = [3, 4]

    # -- plot
    plot(x, y, ls="--", lw=0.1, color="blue", label="blah")
    plot!(2x, 2y, labe="blih")

    assemble_figure(f)
end
