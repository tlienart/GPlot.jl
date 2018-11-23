# GPlot

[WIP]

## What's this about

This package translates your plotting commands into a script digestible by the [Graphics Layout Engine](http://glx.sourceforge.net/index.html) or [Gnuplot](http://www.gnuplot.info/) to generate PNG, PDF, SVG etc.
Both are awesome, mature and powerful softwares that are multi-platform, and very fast.

Translating plotting commands into a script that these programs can handle (which is what GPlot does) takes negligible time, compiling a complex script with GLE or Gnuplot should take `<0.5s` on a modern laptop which means that time-to-first-plot in GPlot is around that much or less.
Significantly faster than common alternatives.

```
               +----------------------------+
        +----> | Generated GLE/Gnuplot code +--+
Julia   |      +----------------------------+  +---> GLE/Gnuplot
code    |                                      |         +
        |         +----------------------+     |         |
        +-------> | Auxiliary data files +-----+         |
                  +----------------------+               v

                                                Output (PDF/PNG/...)
```

This package therefore offers one way to bypass the "time-to-first-plot" which currently exists in Julia (though that issue will hopefully disappear in the future) by wrapping around external binaries.

**Features to be expected**
* Fast plotting experience
* LaTeX compatible
* Output PNG, PDF, SVG etc...
* Publication quality plots
* 2D/3D
* Imperative syntax (†)

† sorry, I come from a Matplotlib background...

**Features that should not be expected**
* Interactivity
* Animation

If you prefer a grammar of graphics style syntax, check out [Gadfly.jl](https://github.com/GiovineItalia/Gadfly.jl) or [VegaLite.jl](https://github.com/fredo-dedup/VegaLite.jl).
If you want animation and an overall more mature plotting library with imperative syntax, check out [Plots.jl](https://github.com/JuliaPlots/Plots.jl), [Makie.jl](https://github.com/JuliaPlots/Makie.jl), [PyPlot.jl](https://github.com/JuliaPy/PyPlot.jl),  [PGFPlots.jl](https://github.com/JuliaTeX/PGFPlots.jl) or [PGFPlotsX.jl](https://github.com/KristofferC/PGFPlotsX.jl).

(And more: [Winston.jl](https://github.com/JuliaGraphics/Winston.jl), [Gaston.jl](https://github.com/mbaz/Gaston.jl), ...)

## What's going on

* (**ongoing**) Wrapper for the [Graphics Layout Engine](http://glx.sourceforge.net/index.html)
* (**upcoming**) Allow both GLE and Gnuplot as backend. Different than Gaston as no attempt at being interactive.
* (**maybe?**) Allow Asymptote as backend. (main advantage is that it ships with any up-to-date texlive)

## Installation

* Get GLE working
    - on Mac, compiling from source does not work (or would require modifying the code in a way that evades me), however getting the DMG file for QGLE and installing the `Ghostscript.framework` as suggested in the tutorial is all that is required.
    - on Fedora, it's available via `yum` but I haven't had the chance to test it.
    - On Ubuntu (I tried with 18.04.1), `sudo apt-get install gle-graphics` does what you expect
* In atom: make sure to tick "enable plot pane" in the julia-client package in order for plots to be displayed in the plot pane...
* Windows things
    - redirect to `/dev/null` is likely not to work (base.show)
    - paths with expanduser etc, likely nok, use joinpath everywhere as well.

## Notes

## Todo

* `lstyle`
    - 9229 should also work (see p21), `split_digits(a::Int)=parse.(Int, [e for e ∈ string(a)])`
