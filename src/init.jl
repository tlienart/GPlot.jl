function __init__()
    # default backend = GLE for now
    print("Looking for a backend...")
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
