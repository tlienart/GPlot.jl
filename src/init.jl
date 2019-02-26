function __init__()
    # check if in IJulia, and if that's the case disable the continuous_preview by default
    isdefined(Main, :IJulia) && Main.IJulia.inited && continuous_preview(false)
    # very simple warmup
    t = @elapsed begin
        f = Figure("_")
        plot([1, 2], [1, 2], ls="--", color="blue")
        plot!([1, 2], lw=0.05, label="blah")
        scatter([1, 2], mcol="red")
        if GP_ENV["HAS_BACKEND"]
            savefig(f, "_", res=100, format="png", path=GP_ENV["TMP_PATH"],_noout=true)
        end
        destroy(f)
    end; println("Init done in $(round(t, digits=2))s.")
    return nothing
end
