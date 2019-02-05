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
        tempdir = mktempdir()
        texpreamble = tex"""
            \usepackage[T1]{fontenc}
            \usepackage[default]{sourcesanspro}
        """
        f = Figure("___", texpreamble=texpreamble)
        x = [1, 2]
        y = [3, 4]

        # -- plot
        plot(x, y, ls="--", lw=0.1, color="blue", label="label1")
        plot!(2x, 2y)
        xlabel("xlabel"); ylabel("ylabel"); title("title")
        legend(pos="tl", fontsize=7)
        xticks([1, 2], ["a", "b"]); yticks([1, 2], ["a", "b"])
        xscale("lin"); yscale("lin")
        xlim(min=0,max=5); ylim(min=0,max=5)
        assemble_figure(f)

        # -- hist
        destroy!(f)
        f = Figure()
        x = rand(10)
        hist(x, fill="cornflowerblue", color="white", scaling="pdf", nbins=50)
        bar(x, x, 2x; stacked=true, fills=["blue","red"], colors=["red","blue"])

        # if there's a working GLE backend, warm that up too
        flag && savefig(f, res=100, format="png", path=tempdir)
    end
    GP_ENV["VERBOSE"] && println(".............done in $(round(t, digits=1))s ✅")
end
