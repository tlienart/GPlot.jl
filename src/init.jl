function __init__()
    # default backend = GLE for now
    print("Looking for a backend...")
    begin
        flag = false
        try
            flag = success(`gle -v`)
            GP_ENV["VERBOSE"] && println(".found GLE ✅")
        catch
        end
        flag || @warn "GLE could not be loaded. Make sure you have installed " *
                      "it and that it is accessible via the shell." *
                      "You will not be able to preview or save figures."
        GP_ENV["BACKEND"] = GLE
    end

    # WARMUP PHASE
    print("Warmup...")
    t = @elapsed begin
        f = Figure("___")
        x = [1, 2]
        y = [3, 4]

        # -- plot
        plot(x, y, ls="--", lw=0.1, color="blue")
        plot!(2x, 2y)

        assemble_figure(f)
    end
    GP_ENV["VERBOSE"] && println(".............done in $(round(t, digits=1))s ✅")
end
