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
(There's probably other libraries that I've missed out.)

## What's going on

* (**ongoing**) Wrapper for the [Graphics Layout Engine](http://glx.sourceforge.net/index.html)
* (**upcoming**) Allow both GLE and Gnuplot as backend. Different than Gaston as no attempt at being interactive.

## Notes

* everything in cm, for font, conversion is `10pt = 0.352778cm` could do `const pt = 0.352778` but it's potentially clashing name, maybe better to have a function that takes point and does the conversion itself.

## Todo

* `lstyle`
    - 9229 should also work (see p21), `split_digits(a::Int)=parse.(Int, [e for e ∈ string(a)])`
