using Documenter, GPlot

makedocs(
    format = Documenter.HTML(
        # Use clean URLs, unless built as a "local" build
        prettyurls = !("local" in ARGS),
        canonical = "https://tlienart.github.io/GPlot.jl/stable/",
    ),
    clean = false,
    sitename = "GPlot.jl",
    authors  = "Thibaut Lienart",
    pages    = [
        "Home" => "index.md",
        "Manual" => [
            "Installation"   => "man/installation.md",  # GLE installation
            "Quick start"    => "man/quickstart.md",    # Simple Figure w plot + preview/save
            "Basic 2D plots" => "man/basicplots.md",    # Scatter2D, Bar, Hist, ...
            "Styling"        => "man/styling.md",       # Figure, Axes, Axis, Fonts, LaTex,..
            "Advanced plots" => "man/advancedplots.md", # Layout, 3D, ...
        ],
        "Library" => [
            "Public"    => "lib/public.md",
            "Internals" => "lib/internals.md",
        ],
    ], # end pages
)

deploydocs(
    repo = "github.com/tlienart/GPlot.jl.git",
    target = "build",
)
