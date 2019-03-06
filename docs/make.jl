using Documenter, GPlot

makedocs(
    modules = [GPlot],
    format = Documenter.HTML(
        # Use clean URLs, unless built as a "local" build
        prettyurls = !("local" in ARGS)
        ),
    sitename = "GPlot.jl",
    authors  = "Thibaut Lienart",
    pages    = [
            "Home" => "index.md",
            "Manual" => [
                "Installation"   => "man/installation.md",  # GLE installation
                "Quick start"    => "man/quickstart.md",    # Simple Figure w plot + preview/save
                "Line & Scatter plots" => "man/line-scatter.md",
                "Hist & Bar plots" => "man/hist-bar.md",
                "Styling"        => "man/styling.md",       # Figure, Axes, Axis, Fonts, LaTex,..
                ],
            "Appendix" => [
                "Fonts" => "appendix/fonts.md",
                ],
            "Library" => [
                "Public"    => "lib/public.md",
                "Internals" => "lib/internals.md",
                ],
            ], # end pages
    assets = ["assets/custom.css"],
)

deploydocs(
    repo = "github.com/tlienart/GPlot.jl.git"
)
