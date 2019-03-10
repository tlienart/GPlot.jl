# GPlot.jl - Documentation

GPlot is a plotting package wrapping the [Graphics Layout Engine](http://glx.sourceforge.net/index.html) (and possibly GnuPlot and/or Asymptote in the future).
The focus is on speed, ease of use and high-quality output.

**Key features**:

* loading time and time-to-first-plot much faster than `Plots.jl` (a couple of seconds),
* handles LaTeX seamlessly,
* handles transparency,
* imperative syntax similar to Matplotlib, Plots.jl, etc.,
* multiple output formats: PNG, PDF, SVG, JPG, EPS or PS.

**What it's not meant for**:

* interactivity (panning, zooming, ...)

**Note**: the package is still being actively developed, feature requests, feedback or contributions are welcome.

## Why GPlot

I discovered the Graphics Layout Engine (GLE) a while back and liked the library though not the syntax and thought a wrapper for GLE in Julia with a matplotlib-like syntax was an interesting project to work on to learn more about graphics and Julia.
A few hundreds of commits later and GPlot.jl is there and may be of interests or even useful to others.

Of course the package is not as mature or feature complete as the current main plotting packages such as [Plots.jl](https://github.com/JuliaPlots/Plots.jl), [Makie.jl](https://github.com/JuliaPlots/Makie.jl), [PyPlot.jl](https://github.com/JuliaPy/PyPlot.jl), [Gadfly.jl](https://github.com/GiovineItalia/Gadfly.jl), [PGFPlots.jl](https://github.com/JuliaTeX/PGFPlots.jl), [PGFPlotsX.jl](https://github.com/KristofferC/PGFPlotsX.jl), etc. which you may prefer if you would rather avoid an experimental library.

## How it works

Basically GPlot translates plotting commands such as `plot(1:5, randn(5))` into

* auxiliary files containing the relevant data,
* a GLE script corresponding to how the data must be drawn.

This is then fed into the GLE engine which produces the desired output.
If LaTeX is used, then the GLE engine uses `pdflatex` in the background (this incurs an overhead).

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

This wrapper is made available under the MIT license.
The GLE program is released under the BSD license (see [the official website](http://glx.sourceforge.net/main/faq.html#license) for more informations).


```@meta
#=
- Appendix/fonts
  - link to tug.dk font catalogue, suggest the ones that work with pdflatex

- when adding text, there's no overwrite (ambiguous) so if it fails you'll need to use `cla()` liberally. same if you want to change from notex to latex mode use cla or clf and then set(gcf, tex=true) and then go again. Can use `clo!` to remove objects leaving rest
unchanged

- API

-- plotting stuff with ! = append
-- everything else doesn't have ! bc confusing

- Latex

-- t"x^{\star}" will work but t"\sqrt" won't unless you use TeX in the figure. (need to show examples for this)
-- \it , \bf

=#
```
