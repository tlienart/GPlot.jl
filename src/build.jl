# default backend = GLE for now
# a lot of this code is imitated from PGFPlotsX.jl

print(stderr, "Looking for a backend...")
have_gle = try success(`gle -v`); catch; false; end

if have_gle
    GP_ENV["BACKEND"]     = GLE
    GP_ENV["HAS_BACKEND"] = true
    println(stderr, "  found ✅ ")
else
    @warn "GLE could not be loaded. Make sure you have installed it and that it is accessible via
           the shell. You will not be able to preview or save figures."
    GP_ENV["BACKEND"] = GLE # still setting a default backend (only for type purposes + tests)
    println(stderr, "  not found 🚫 ")
end

for dep ∈ ["latex", "pdflatex", "dvips", "gs"]
    print(stderr, "Looking for $dep...")
    have_dep = try success(`$dep -v`); catch; false; end
    if have_dep
        println(stderr, "  found ✅ ")
    else
        @warn "Dependency $dep is missing, you may have issues previewing or saving figures."
        println(stderr, "  not found 🚫 ")
    end
end
