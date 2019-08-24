# GPlot.jl - Documentation

GPlot is a plotting package wrapping the [Graphics Layout Engine](http://glx.sourceforge.net/index.html) (⭒).
The focus is on reasonable speed, ease of use and high-quality output.

(⭒) and possibly, in some unspecified future, with GnuPlot and Asymptote.

**Key features**:

* loading time and time-to-first-plot much faster than [`Plots.jl`](https://github.com/JuliaPlots/Plots.jl) (a couple of seconds),
* handles LaTeX seamlessly,
* handles transparency,
* imperative syntax similar to Matplotlib, Plots.jl, etc.,
* multiple output formats: PNG, PDF, SVG, JPG, EPS or PS.

**What it's not meant for**:

* interactivity (panning, zooming, ...)
* generating videos (while a single plot will feel fast, generating a sequence of plots will feel slow, around 8-10 plots per second)

**Note**: the package is still being actively developed, feature requests, feedback or contributions are welcome.

## Why GPlot?

I discovered the Graphics Layout Engine (GLE) a while back and liked what it could do though not its syntax and thought a wrapper for GLE in Julia with a matplotlib-like syntax was an interesting project to work on to learn more about Julia and about data visualisation.

The package is not as mature or feature complete as the current main plotting packages such as [Plots.jl](https://github.com/JuliaPlots/Plots.jl), [Makie.jl](https://github.com/JuliaPlots/Makie.jl), [PyPlot.jl](https://github.com/JuliaPy/PyPlot.jl), [Gadfly.jl](https://github.com/GiovineItalia/Gadfly.jl), [PGFPlots.jl](https://github.com/JuliaTeX/PGFPlots.jl), [PGFPlotsX.jl](https://github.com/KristofferC/PGFPlotsX.jl), etc. which you may prefer if you would rather avoid an experimental library.

## How it works

GPlot translates plotting commands such as `plot(1:5, randn(5))` into

* one or several auxiliary files containing the relevant data,
* a GLE script corresponding to how the data must be drawn.

This is then passed to the GLE engine which produces the desired output.
If LaTeX is used, the GLE engine also uses `pdflatex` in the background to produce the output (this incurs an overhead).

The diagram below illustrates the workflow:

```
                +----------------------+
          +---> | Generated GLE code   +---+
Julia     |     +----------------------+   +---> GLE engine
code   ---+                                |         +
          |     +----------------------+   |         |
          +---> | Auxiliary data files +---+         |
                +----------------------+         (pdflatex)
                                                     |
                                                     |
                                                     v
                                              Output (PDF/PNG/...)
```

eventually the auxiliary files are removed (unless the user requests to keep them).

## License

* GPlot is MIT licensed.
* The GLE program is released under the BSD license (see [the official website](http://glx.sourceforge.net/main/faq.html#license) for more informations).
