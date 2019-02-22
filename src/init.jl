function __init__()
    # very simple warmup
    t = @elapsed begin
        f = Figure("_")
        plot([1, 2], [1, 2], ls="--", color="blue")
        legend()
        xlabel("hello"); ylabel("hello"); xlim(0,1); ylim(0,1)
        if GP_ENV["HAS_BACKEND"]
            savefig(f, "_", res=100, format="png", path=GP_ENV["TMP_PATH"],_noout=true)
        end
        destroy(f)
    end; println("Init done in $(round(t, digits=2))s.")
    return nothing
end
