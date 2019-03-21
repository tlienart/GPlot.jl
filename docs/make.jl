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
            "Installation"         => "man/installation.md",
            "Quick start"          => "man/quickstart.md",
            "Line & Scatter plots" => "man/line-scatter.md",
            "Hist & Bar plots"     => "man/hist-bar.md",
            "Legend"               => "man/legend.md",
            "Axes and Axis"        => "man/figure-axes-axis.md",
            "Styling"              => "man/styling.md",
            "Boxplot"              => "man/boxplot.md",
            "Heatmap"              => "man/heatmap.md",
            "Annotations"          => "man/annotations.md",
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
