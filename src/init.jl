function __init__()
    # very simple warmup
    # XXX this doesn't look like it help time to first plot
    # because the slowest part is actually opening and activating the
    # JUNO panel...


    # t = @elapsed begin
    #     continuous_preview(false)
    #     f = Figure("_")
    #     plot([1, 2], [1, 2], ls="--", color="blue")
    #     plot!([1, 2], lw=0.05, label="blah")
    #     scatter([1, 2], mcol="red")
    #     if GP_ENV["HAS_BACKEND"]
    #         savefig(f, "_", res=100, format="png", path=GP_ENV["TMP_PATH"],_noout=true)
    #     end
    #     destroy(f)
    # end; println("Init done in $(round(t, digits=2))s.")

    # check if in IJulia, and if that's the case disable the continuous_preview by default
    isdefined(Main, :IJulia) && Main.IJulia.inited && continuous_preview(false)
    isdefined(Main, :Atom) && Main.Atom.PlotPaneEnabled.x && continuous_preview(true)
    return nothing
end
