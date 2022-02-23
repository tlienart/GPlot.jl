function __init__()
    have_gle = try success(`gle -v`); catch; false; end

    if have_gle
        GP_ENV["BACKEND"]     = GLE
        GP_ENV["HAS_BACKEND"] = true
    else
        @warn "GLE could not be loaded. Make sure you have installed it and that it is accessible via
               the shell. You will not be able to preview or save figures."
        GP_ENV["BACKEND"] = GLE # still setting a default backend (only for type purposes + tests)
        println(stderr, "  not found 🚫 ")
    end

    for dep ∈ ["latex", "pdflatex", "dvips", "gs"]
        have_dep = try success(`$dep -v`); catch; false; end
        if !have_dep
            @warn "Dependency $dep is missing, you may have issues previewing or saving figures."
        end
    end

    isdefined(Main, :IJulia) && Main.IJulia.inited && continuous_preview(false)
    isdefined(Main, :Atom)   && Main.Atom.PlotPaneEnabled.x && continuous_preview(true)
    return nothing
end
