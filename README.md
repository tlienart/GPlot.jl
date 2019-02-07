# GPlot

| Status | Coverage | Documentation |
| :----: | :------: | :-----------: |
| [![Build Status](https://travis-ci.org/tlienart/GPlot.jl.svg?branch=master)](https://travis-ci.org/tlienart/GPlot.jl) | [![codecov.io](http://codecov.io/github/tlienart/GPlot.jl/coverage.svg?branch=master)](http://codecov.io/github/tlienart/GPlot.jl?branch=master) | [![](https://img.shields.io/badge/docs-dev-blue.svg)](https://tlienart.github.io/GPlot.jl/dev)


[WIP] If you think this project could be fun to work on and would like to help, I'll be happy to hear from you (even if just to help me test the code).

## What's this about

This package translates plotting commands into a script digestible by the [Graphics Layout Engine](http://glx.sourceforge.net/index.html) (and possibly GnuPlot in the future) to generate PNG, PDF, SVG etc.
Both GLE and GnuPlot are great and mature libraries that are multi-platform and quite fast.

Translating plotting commands into a script that these programs can handle (which is what GPlot does) takes negligible time, and the code is not very complicated meaning that

* time to first plot will be a couple of seconds (short pre-compilation overhead)
* subsequent plotting time will be very quick
* for plots with LaTeX, there is a small overhead since there is an extra pass required to go through the LaTeX engine


The diagram below illustrates how `GPlot` works with the `GLE` backend.

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

**Features**
* Fast plotting experience including low time to first plot
* LaTeX compatible
* Output PNG, PDF, SVG etc...
* 2D/3D
* Imperative syntax a-la matplotlib

**Features that should not be expected**
* Interactivity
* Animation

### Alternatives

If you prefer a grammar of graphics style syntax, check out [Gadfly.jl](https://github.com/GiovineItalia/Gadfly.jl), [VegaLite.jl](https://github.com/fredo-dedup/VegaLite.jl) or use ggplot2 via [RCall.jl](https://github.com/JuliaInterop/RCall.jl).

If you want animation and an overall more mature plotting library with imperative syntax, check out [Plots.jl](https://github.com/JuliaPlots/Plots.jl), [Makie.jl](https://github.com/JuliaPlots/Makie.jl), [PyPlot.jl](https://github.com/JuliaPy/PyPlot.jl),

There's also [PGFPlots.jl](https://github.com/JuliaTeX/PGFPlots.jl) or [PGFPlotsX.jl](https://github.com/KristofferC/PGFPlotsX.jl) which are wrappers for PGFTeX. And a few more packages (I don't know them all) like [Winston.jl](https://github.com/JuliaGraphics/Winston.jl) or [Gaston.jl](https://github.com/mbaz/Gaston.jl).

## What's going on

* (**ongoing**) Wrapper for the [Graphics Layout Engine](http://glx.sourceforge.net/index.html)
* (**considered**) Allow Gnuplot and maybe Asymptote as backend. Different than Gaston as no attempt at being interactive. Main advantage of asymptote is that it ships with any up-to-date texlive.

## Installation

To install the package, the usual command for unregistered packages applies:

```julia
] add https://github.com/tlienart/GPlot.jl
```

To get GLE working (there may be other/simpler approaches that work, please let me know), please follow the instructions further below depending on your OS.
After following the instructions, check in Julia that the following command works:

```julia-repl
julia> run(`gle -v`)
GLE version 4.2.4c
Usage: gle [options] filename.gle
More information: gle -help
Process(`gle -v`, ProcessExited(0))
```

### On Linux

**Tested**

* Ubuntu: `sudo apt-get install gle-graphics`

**Untested**

* Fedora, CentOS via `yum install gle`
* Other distros (_your help is appreciated!_)

### On MacOS

(*There may be simpler approaches but I'm sure this one works and fairly easy.*)

The original instructions ([here](http://glx.sourceforge.net/tut/mac.html)) are reproduced below for convenience:

1. Get the Ghostscript dmg [from sourceforge](http://prdownloads.sourceforge.net/glx/Ghostscript-8.63.dmg?download) and copy-paste its content (`Ghostscript.framework`) in `/Library/Frameworks/`
1. Get the Q-GLE dmg [from sourceforge](http://prdownloads.sourceforge.net/glx/gle-graphics-4.2.4c-exe-mac.dmg?download) and put it in your `/Applications/` folder

This should now work in your terminal:

```bash
~> /Applications/QGLE.app/Contents/bin/gle -v
GLE version 4.2.4c
Usage: gle [options] filename.gle
More information: gle -help
```

The only thing left to do is to link the right parts to `/usr/local/` so that `gle` can be called from Julia easily.
(The following lines may tell you that the link to `libpng` already exists, that's fine.)

```bash
ln -s /Applications/QGLE.app/Contents/bin/gle /usr/local/bin/.
ln -s /Applications/QGLE.app/Contents/bin/glegs /usr/local/bin/.
ln -s /Applications/QGLE.app/Contents/lib/libgle-graphics-4.2.4c.dylib /usr/local/lib/.
ln -s /Applications/QGLE.app/Contents/lib/libpng.dylib /usr/local/lib/.
ln -s /Applications/QGLE.app/Contents/share/gle-graphics/ /usr/local/share/.
```

### On Windows

I haven't tested this on Windows but there are executables available on the [GLE downdloads page](http://glx.sourceforge.net/downloads/downloads.html) which should work (one has been updated very recently).

_If you've managed to make things work for you on Windows, please let me know so that I can improve these instructions!_

## License

This wrapper is made available under  MIT license.
The GLE program is released under the BSD license (see [the official website](http://glx.sourceforge.net/main/faq.html#license) for more informations).
