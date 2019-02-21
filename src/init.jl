function __init__()
    # very simple warmup
    t = @elapsed begin
        f = Figure("_")
        if GP_ENV["HAS_BACKEND"]
            savefig(f, "_", res=100, format="png", path=GP_ENV["TMP_PATH"],_noout=true)
        end
        destroy(f)
    end
    return nothing
end
