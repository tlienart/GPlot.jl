# GPlot.jl - Documentation

GPlot is a plotting package wrapping the [Graphics Layout Engine](http://glx.sourceforge.net/index.html) (and possibly GnuPlot and/or Asymptote in the future).
The focus is on speed, ease of use and high-quality output.

**Key features**:

* loading time and time-to-first-plot much faster than [`Plots.jl`](https://github.com/JuliaPlots/Plots.jl) (a couple of seconds),
* handles LaTeX seamlessly,
* handles transparency,
* imperative syntax similar to Matplotlib, Plots.jl, etc.,
* multiple output formats: PNG, PDF, SVG, JPG, EPS or PS.

**What it's not meant for**:

* interactivity (panning, zooming, ...)

**Note**: the package is still being actively developed, feature requests, feedback or contributions are welcome.

## Why GPlot?

I discovered the Graphics Layout Engine (GLE) a while back and liked what it could do though not the syntax and thought a wrapper for GLE in Julia with a matplotlib-like syntax was an interesting project to work on to learn more about graphics and Julia.

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

## License

* GPlot is MIT licensed.
* The GLE program is released under the BSD license (see [the official website](http://glx.sourceforge.net/main/faq.html#license) for more informations).
