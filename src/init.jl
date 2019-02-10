function __init__()
    # default backend = GLE for now
    print("Looking for a backend...")
    begin
        hasbackend = false
        try
            hasbackend = success(`gle -v`)
            GP_ENV["VERBOSE"] && println(".found GLE ✅")
        catch
        end
        hasbackend || @warn "GLE could not be loaded. Make sure you have installed " *
                            "it and that it is accessible via the shell." *
                            "You will not be able to preview or save figures."
        GP_ENV["BACKEND"] = GLE
    end

    # WARMUP PHASE
    GP_ENV["WARMUP"] || return

    print("Warmup...")
    t = @elapsed begin
        tempdir = mktempdir()

        f = Figure("___")
        x, y = [1, 2], [3, 4]
        x2 = range(1, stop=2, length=50)
        y2 = exp.(x2)

        # -- plot
        plot(x, y)
        plot(2x, 2y, ls="--", lw=0.1, color="blue", label="label1")
        plot!(x2, y2, lwidth=0.02)
        xlabel("xlabel"); ylabel("ylabel"); title("title")
        legend(pos="tl", fontsize=7)
        xticks([1, 2], ["a", "b"]); yticks([1, 2], ["a", "b"])
        xscale("lin"); yscale("lin")
        xlim(min=0,max=5); ylim(min=0,max=5)
        assemble_figure(f)
        hasbackend && savefig(f, res=100, format="png", path=tempdir)

        # -- hist
        destroy!(f)
        f = Figure()
        x = rand(10)
        hist(x, fill="cornflowerblue", color="white", scaling="pdf", nbins=50)
        bar(x, x, 2x; stacked=true, fills=["blue","red"], colors=["red","blue"])
        assemble_figure(f)

        # if there's a working GLE backend, warm that up too
        hasbackend && savefig(f, format="pdf", path=tempdir)

        # clear everything
        destroy!(f)
    end
    GP_ENV["VERBOSE"] && println(".............done in $(round(t, digits=1))s ✅")
    return
end
