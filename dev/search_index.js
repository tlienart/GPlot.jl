var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "#GPlot.jl-Documentation-1",
    "page": "Home",
    "title": "GPlot.jl - Documentation",
    "category": "section",
    "text": "GPlot is a plotting package wrapping the Graphics Layout Engine (and possibly GnuPlot or Asymptote in the future). The focus is on speed, ease of use and high-quality output.Key features:loading time and time to first plot much faster than Plots.jl (a couple of seconds),\nhandles LaTeX seamlessly,\nhandles transparency,\nimperative syntax similar to Matplotlib, Plots.jl, etc.,\nmultiple output formats: PNG, PDF, SVG, JPG, EPS or PS.What it\'s not meant for:interactivity (panning, zooming, ...)Note: the package is still being actively developed, feature requests, feedback or contributions are welcome."
},

{
    "location": "#Why-GPlot-1",
    "page": "Home",
    "title": "Why GPlot",
    "category": "section",
    "text": "I discovered GLE a while back and liked the library though not the syntax and thought a wrapper for GLE in Julia with a matplotlib-like syntax was an interesting project to work on to learn more about graphics and Julia. A few hundreds of commits later and GPlot.jl is there and may be of interests or even useful to others.Of course the package is not as mature or feature complete as the current main plotting packages such as Plots.jl, Makie.jl, PyPlot.jl, Gadfly.jl, PGFPlots.jl, PGFPlotsX.jl, etc which you may prefer if you would rather avoid an experimental library."
},

{
    "location": "#How-it-works-1",
    "page": "Home",
    "title": "How it works",
    "category": "section",
    "text": "Basically GPlot translates plotting commands such as plot(1:5, randn(5)) intoauxiliary files containing the relevant data,\na GLE script corresponding to how the data must be drawn.This is then fed into the GLE engine which produces the desired output. If LaTeX is used, then the GLE engine uses pdflatex in the background (this incurs an overhead).The diagram below illustrates the workflow:                +----------------------+\n          +---> | Generated GLE code   +---+\nJulia     |     +----------------------+   +---> GLE engine\ncode   ---+                                |         +\n          |     +----------------------+   |         |\n          +---> | Auxiliary data files +---+         |\n                +----------------------+         (pdflatex)\n                                                     |\n                                                     |\n                                                     v\n                                              Output (PDF/PNG/...)"
},

{
    "location": "#License-1",
    "page": "Home",
    "title": "License",
    "category": "section",
    "text": "This wrapper is made available under the MIT license. The GLE program is released under the BSD license (see the official website for more informations).#=\nTodo:\n- work out how to have syntax highlighting\n\n- Appendix/fonts\n  - link to tug.dk font catalogue, suggest the ones that work with pdflatex\n\n- preview mode: if in a wrapped scope, the continuous preview will\nnot happen, need to explicitly call preview for instance\n@elapsed text!(...) will not display unless preview is called explicitly\n\n- when adding text, there\'s no overwrite (ambiguous) so if it fails you\'ll need to use `cla()` liberally. same if you want to change from notex to latex mode use cla or clf and then set(gcf, tex=true) and then go again. Can use `clo!` to remove objects leaving rest\nunchanged\n\n- API\n\n-- plotting stuff with ! = append\n-- everything else doesn\'t have ! bc confusing\n\n- Latex\n\n-- t\"x^{\\star}\" will work but t\"\\sqrt\" won\'t unless you use TeX in the figure. (need to show examples for this)\n-- \\it , \\bf\n\n=#"
},

{
    "location": "man/installation/#",
    "page": "Installation",
    "title": "Installation",
    "category": "page",
    "text": ""
},

{
    "location": "man/installation/#Installation-1",
    "page": "Installation",
    "title": "Installation",
    "category": "section",
    "text": "To work with GPlot, you will need three things:Julia ≥ 1.0\nthe GPlot package,\nthe GLE engine,Note: if you intend to use LaTeX, you will also need to have pdflatex.To install the package in Julia, the usual command for unregistered packages applies:] add https://github.com/tlienart/GPlot.jlTo get GLE working, please follow the instructions further below depending on your OS. After following the instructions, check in Julia that the following command works (the version number may differ a bit depending on your OS):julia> run(`gle -v`)\nGLE version 4.2.4c\nUsage: gle [options] filename.gle\nMore information: gle -help\nProcess(`gle -v`, ProcessExited(0))note: Note\nIf you encounter problems with the instructions below or believe that the instructions could be simplified, please open an issue. Also if you managed to follow the instructions successfully with an OS that\'s not explicitly on the list below, please let me know and I can add it here."
},

{
    "location": "man/installation/#Installing-GLE-on-Linux-1",
    "page": "Installation",
    "title": "Installing GLE on Linux",
    "category": "section",
    "text": "TestedUbuntu: sudo apt-get install gle-graphicsUntestedFedora, CentOS via yum install gle\nOther distros (your help is appreciated!)"
},

{
    "location": "man/installation/#Installing-GLE-on-MacOS-1",
    "page": "Installation",
    "title": "Installing GLE on MacOS",
    "category": "section",
    "text": "(There may be a simpler approach but I\'m sure this one works and fairly easy.)Tested: Mojave, High Sierra. (afaik, there\'s no reason it shouldn\'t work on older versions)The original instructions (here) are reproduced below for convenience:Get the Ghostscript dmg from sourceforge and copy-paste its content (Ghostscript.framework) in /Library/Frameworks/ (do that even if you already have GS)\nGet the QGLE dmg from sourceforge and put its content in your /Applications/ folderThis should now work in your terminal:~> /Applications/QGLE.app/Contents/bin/gle -v\nGLE version 4.2.4c\nUsage: gle [options] filename.gle\nMore information: gle -helpThe only thing left to do is to link the right parts to /usr/local/ so that gle can be called from Julia easily. (The following lines may tell you that the link to libpng already exists, that\'s fine.)ln -s /Applications/QGLE.app/Contents/bin/gle /usr/local/bin/.\nln -s /Applications/QGLE.app/Contents/bin/glegs /usr/local/bin/.\nln -s /Applications/QGLE.app/Contents/lib/libgle-graphics-4.2.4c.dylib /usr/local/lib/.\nln -s /Applications/QGLE.app/Contents/lib/libpng.dylib /usr/local/lib/.\nln -s /Applications/QGLE.app/Contents/share/gle-graphics/ /usr/local/share/."
},

{
    "location": "man/installation/#Installing-GLE-on-Windows-1",
    "page": "Installation",
    "title": "Installing GLE on Windows",
    "category": "section",
    "text": "I haven\'t tested this on Windows but there are executables available on the GLE downdloads page which should-just-work™ (one has been updated quite recently).If you\'ve managed to make things work for you on Windows, please let me know so that I can improve these instructions!"
},

{
    "location": "man/quickstart/#",
    "page": "Quick start",
    "title": "Quick start",
    "category": "page",
    "text": ""
},

{
    "location": "man/quickstart/#Quickstart-1",
    "page": "Quick start",
    "title": "Quickstart",
    "category": "section",
    "text": "Once both GLE and GPlot are successfully installed, this short tutorial should give a feeling for how things work; for more detailed instructions refer to the rest of the manual. We will draw a simple plot with two curves, labels, and basic axis styling.Let\'s start by creating a simple figure:fig = Figure()note: Note\nIt is not required to explicitly call Figure(); if no figure currently exists, the first plotting command will generate one with default parameters.Let\'s now define a function over the range [-2.5, 2.5] and plot it:x = range(-2.5, stop=2.5, length=100)\ny = @. exp(-x^2) * sin(x)\nplot(x, y, label=\"plot 1\")\nlegend()where we\'ve used the @. syntax to indicate that the operations are done pointwise on x (broadcasting). The syntax should hopefully feel reasonable thus far.(Image: )Let\'s add another curve on this figure and change the colour; let\'s also specify axis limits, where the ticks have to be etc:y2 = @. sin(x^2) * exp(-x/10)\nplot!(x, y2, col=\"blue\", lwidth=0.05, label=\"plot 2\")\n\nxlabel(\"x-axis\")\nylabel(\"y-axis\")\nxticks([-pi/2, 0, pi/2], [\"π/2\", \"0\", \"π/2\"])\nylim(-1.5, 1.5)\nyticks(-1:0.25:1)\n\nlegend()One thing worth noting at this point is that we follow Plots.jl\'s convention adding a ! after plot to indicate that it should modify the current graph without overwriting it (i.e. the new curve is added on top of the existing one).(Image: )Now we can save this figure:savefig(fig, \"my_first_figure.pdf\")the command picks up the format (here .pdf) saves the file in the current folder.comment: Comment\nIf you got this far thinking that all this seems reasonable, have a look at the rest of the doc to learn how to plot what you want and how you want it 📊 , happy plotting!"
},

{
    "location": "man/line-scatter/#",
    "page": "Line & Scatter plots",
    "title": "Line & Scatter plots",
    "category": "page",
    "text": ""
},

{
    "location": "man/line-scatter/#Line-and-scatter-plot-1",
    "page": "Line & Scatter plots",
    "title": "Line and scatter plot",
    "category": "section",
    "text": ""
},

{
    "location": "man/line-scatter/#Basic-syntax-1",
    "page": "Line & Scatter plots",
    "title": "Basic syntax",
    "category": "section",
    "text": "The relevant commands here areplot and plot! (2D lines connecting points, no markers by default)\nscatter, scatter! (markers showing a set of points, no line by default)The general syntax is:command(data_to_plot...; options...)a command with an exclamation mark will add the corresponding plot to the current active axes while a command without will erase any existing plot on the current active axes and then display the plot.For instance:x = range(-2.5, stop=2.5, length=100)\ny = @. exp(-x^2) * sin(x)\nplot(x, y)\nmask = 1:5:100\nscatter!(x[mask], y[mask])overlays a scatterplot to a line plot:(Image: )"
},

{
    "location": "man/line-scatter/#Data-formats-1",
    "page": "Line & Scatter plots",
    "title": "Data formats",
    "category": "section",
    "text": "The table below summarises the different ways you can specify what data to plot, they are discussed in more details and with examples below.Form Example Comment\nsingle vector x plot(randn(5)) pairs (i x_i)\ntwo vectors xy plot(randn(5),randn(5)) pairs (x_iy_i)\nmultiple vectors xyz plot(randn(5),randn(5),randn(5)) pairs (x_iy_i), (x_iz_i), ...\nsingle matrix X plot(randn(5,2)) pairs (i x_i1), (i x_i2), ...\none vector then vectors or matrices plot(1:5, randn(5,2), randn(5)) pairs between the first vector and subsequent columns\nfunction f from to plot(sin, 0, pi) draws points x_i on the interval and plots pairs (x_i f(x_i))Single vector x: the plot will correspond to the pairs (i x_i).For instance:plot(randn(5))(Image: )Two vectors x, y: the plot will correspond to the pairs (x_i y_i) (see e.g. the example earlier)\nMultiple vectors x, y, z: this will create multiple plots corresponding to the pairs (x_i y_i), (x_i z_i) etc.For instance:x = range(0, 1, length=100)\nplot(x, x.^2, x.^3, x.^4)(Image: )Single matrix X: the plots will correspond to the pairs (i X_i1), (i X_i2) etc.For instance:plot(randn(10, 3))(Image: )vector and matrices or vector x, Y, Z: will form plots corresponding to the pairs of x and each column in Y, Z etc.For instance:x = range(0, 1, length=25)\ny = @. sin(x)\nz = @. cos(x)\nt = y .+ z\nscatter(x, hcat(y, z), t)(Image: )function: will draw points on the specified range and draw (x_i f(x_i)).For instance:scatter(sin, 0, 2π; msize=0.1)\nxlim(0,2π)(Image: )"
},

{
    "location": "man/line-scatter/#Styling-options-1",
    "page": "Line & Scatter plots",
    "title": "Styling options",
    "category": "section",
    "text": "Line and scatter plots have effectively two things they can get styled:the line styles\nthe marker stylesNote the plural, so that if you are plotting multiple lines at once, each keyword accepts a vector of elements to style the individual plots. If a styling option is specified with a single value but multiple lines are being plotted, all will have that same value for the relevant option.For instance:plot(randn(10, 3), colors=[\"violet\", \"navyblue\", \"orange\"], lwidth=0.1)(Image: )note: Note\nGPlot typically accepts multiple aliases for option names, pick whichever one you like, that sticks best to mind or that you find the most readable."
},

{
    "location": "man/line-scatter/#Line-style-options-1",
    "page": "Line & Scatter plots",
    "title": "Line style options",
    "category": "section",
    "text": "For each of these options, it should be understood that you can either pass a single value or a vector of values.line style [ls , lstyle, linestyle, lstyles and linestyles]: take a string describing how the line(s) will look like.Value Result Comment\n\"-\" (Image: ) default for plot\n\"--\" (Image: ) \n\"-.\" (Image: ) \n\"none\"  default for scatterline width [lw, lwidth, linewidth, lwidths and linewidths]: take a positive number describing how thick the line should be in centimeters.Value Result Comment\n0.001 (Image: ) \n0.01 (Image: ) \n0.05 (Image: ) \n0.1 (Image: ) \n0 (Image: ) default value, corresponds to 0.02line color [col, color, cols and colors]: take a string (most SVG color name) or a Color object (from the Colors.jl package) describing how the line should be coloured.Value Result\n\"cornflowerblue\" (Image: )\n\"forestgreen\" (Image: )\n\"indigo\" (Image: )\n\"RGB(0.5,0.7,0.2)\" (Image: )Note that if the colour is not specified, a default colour will be taken by cycling through a colour palette.smoothness: [smooth and smooths]: take a boolean indicating whether the line interpolating between the points should be made out of straight lines (default, smooth=false) or out of interpolating splines (smooth=true). The latter may look nicer for plots that represent a continuous function when there aren\'t many points.x = range(-2, 2, length=20)\ny1 = @. sin(exp(-x)) + 0.5\ny2 = @. sin(exp(-x)) - 0.5\nplot(x, y1; label=\"unsmoothed\")\nplot!(x, y2; smooth=true, label=\"smoothed\")\nlegend()(Image: )Here\'s another example combining several options:x = range(0, 2, length=100)\nfor α ∈ 0.01:0.05:0.8\n    plot!(x, x.^α, lwidth=α/10, col=RGB(0.0,0.0,α), smooth=true)\nend(Image: )"
},

{
    "location": "man/line-scatter/#Marker-style-options-1",
    "page": "Line & Scatter plots",
    "title": "Marker style options",
    "category": "section",
    "text": ""
},

{
    "location": "man/line-scatter/#Notes-1",
    "page": "Line & Scatter plots",
    "title": "Notes",
    "category": "section",
    "text": "Infinities, NaNs and Missing values are all treated the same way: they\'re not shown.TBDplot is tied to data, if data changes, the plot will change too, so should be careful. Note that this is ONLY if the data is modified in place. So for instancex = randn(5)\ny = randn(5)\nplot(x, y)\nx = zeros(5)\nxlabel(\"blah\") # the graph will not have changedhoweverx = randn(5)\ny = randn(5)\nplot(x, y)\nx[1] = 0.0\nxlabel(\"blah\") # here the first point will be (0.0, y[1])Inf, NaN and Missings are all considered in the same way (as missings)."
},

{
    "location": "man/line-scatter/#Bar-plot-1",
    "page": "Line & Scatter plots",
    "title": "Bar plot",
    "category": "section",
    "text": ""
},

{
    "location": "man/hist-bar/#",
    "page": "Hist & Bar plots",
    "title": "Hist & Bar plots",
    "category": "page",
    "text": ""
},

{
    "location": "man/hist-bar/#Advanced-Plots-1",
    "page": "Hist & Bar plots",
    "title": "Advanced Plots",
    "category": "section",
    "text": "TBALaTeX only pdflatex\ncan use basic Latex without actual tex mode (see appendix A3) for instance sub/super-scripts. This can work fine for a lot of simple things and avoids the overhead of pdflatex. Basically all greek letters, most standard maths ops, should link to extracted page 89 of the manual."
},

{
    "location": "man/styling/#",
    "page": "Styling",
    "title": "Styling",
    "category": "page",
    "text": ""
},

{
    "location": "man/styling/#Styling-1",
    "page": "Styling",
    "title": "Styling",
    "category": "section",
    "text": "Pages = [\"styling.md\"]"
},

{
    "location": "man/styling/#Figure-1",
    "page": "Styling",
    "title": "Figure",
    "category": "section",
    "text": "transparency should not be used unless you really need to as it restricts the device you can use to only PNG as well as the fonts you can use. Effectively transparency should only be used for fillbetween and possibly overlapping histograms."
},

{
    "location": "man/styling/#Axes-and-Axis-1",
    "page": "Styling",
    "title": "Axes and Axis",
    "category": "section",
    "text": "TBD:note that x2axis/y2axis revert to xaxis/yaxis (GLE restriction)\ncannot have xaxis off and x2axis on, same for y\nif xticks happens after grid it will disable, should use xticks! if want to change position\nticks angle are in degrees, rotation is clockwise (e.g. 45)"
},

{
    "location": "man/styling/#Legend-1",
    "page": "Styling",
    "title": "Legend",
    "category": "section",
    "text": "can be constructed but watchout for grouped objects, it will currently fail, would need some thinking"
},

{
    "location": "man/styling/#Misc-1",
    "page": "Styling",
    "title": "Misc",
    "category": "section",
    "text": "TBDpass styles around using splatting, don\'t forget the ; otherwise it will fail.style = (smooth=true, lw=0.05, ls=\"--\")\nplot(randn(50); style...)"
},

{
    "location": "man/styling/#LineStyle-1",
    "page": "Styling",
    "title": "LineStyle",
    "category": "section",
    "text": "TBD:default to smooth if more than 20 points."
},

{
    "location": "man/styling/#Fonts-1",
    "page": "Styling",
    "title": "Fonts",
    "category": "section",
    "text": "TBD:if things look weird (e.g. the font does not look like the one you thought you had picked), it may be that the effective font size is too low, try increasing the size of the figure.The parent font of the figure can be defined by passing it as argument to the constructor Figure(font=...). In non-LaTeX mode, different fonts can be selected for sub-elements (e.g. axis label); otherwise the parent font is used throughout."
},

{
    "location": "man/styling/#Non-LaTeX-mode-1",
    "page": "Styling",
    "title": "Non-LaTeX mode",
    "category": "section",
    "text": "In non-tex mode, a number of fonts and font-variants are supported, see the appendix for the full list.The table below is a subset of the supported fonts that are likely to be among the most useful. Note that not all fonts are supported for the SVG/Cairo output (cairo being required when transparency is desired).You can specify the font you want using its ID or its name (replacing spaces by dashes) for instance:f = Figure(font=\"texmr\")\nf2 = Figure(font=\"computer-modern-roman\")are both valid way of defining the parent font.Note 1: most fonts only have basic symbol support (typically Greek letters are fine) but will fail for more \"exotic\" symbols like ∫ or ∞. Use the  LaTeX mode for those. Note 2: the fonts that start with tex are tex-like fonts but do not switch on the LaTeX mode.ID Name Looks like SVG/Cairo\npsh helvetica (Image: ) ✘\npspr palatino roman (Image: ) ✘\ntexcmr computer modern roman (Image: ) ✔\ntexcmss computer modern sans serif (Image: ) ✔\ntexcmtt computer modern sans serif (Image: ) ✔\narial8 arial (Image: ) ✘\nrm roman (Image: ) ✘\nss sans serif (Image: ) ✘\ntt typewriter (Image: ) ✘"
},

{
    "location": "man/styling/#LaTeX-mode-1",
    "page": "Styling",
    "title": "LaTeX mode",
    "category": "section",
    "text": "In LaTeX mode, you\'re free to specify your own preamble which can include font packages to define how things should look. Anything that works with PdfLaTeX should work. Below is an example where we use sourcesanspro:preamble = texpreamble = tex\"\"\"\n    \\usepackage[T1]{fontenc}\n    \\usepackage[default]{sourcesanspro}\n    \\usepackage{amssymb}\n\"\"\"\nf = Figure(texpreamble=preamble)Note: specifying a tex preamble is sufficient to switch to LaTeX mode."
},

{
    "location": "appendix/fonts/#",
    "page": "Fonts",
    "title": "Fonts",
    "category": "page",
    "text": ""
},

{
    "location": "appendix/fonts/#Fonts-1",
    "page": "Fonts",
    "title": "Fonts",
    "category": "section",
    "text": "This page contains a list of all supported fonts when not in LaTeX mode and a few examples of fonts in LaTex mode. For a simple list of reasonable fonts in non-latex mode see here.Pages = [\"fonts.md\"]"
},

{
    "location": "appendix/fonts/#Non-LaTeX-mode-1",
    "page": "Fonts",
    "title": "Non-LaTeX mode",
    "category": "section",
    "text": "The list below shows what these fonts look like and whether SVG output is supported.ID Aliases Looks like SVG/Cairo\nrm roman (Image: ) ✘\nrmb roman bold (Image: ) ✘\nrmi roman italic (Image: ) ✘\nss sans serif (Image: ) ✘\nssb sans serif bold (Image: ) ✘\nssi sans serif italic (Image: ) ✘\ntt typewriter (Image: ) ✘\nttb typewriter bold (Image: ) ✘\nttbi typewriter bold italic (Image: ) ✘\ntti sans serif (Image: ) ✘\ntexcmr computer modern roman (Image: ) ✔\ntexcmb computer modern bold (Image: ) ✔\ntexcmti computer modern text italic (Image: ) ✔\ntexcmmi computer modern maths italic (Image: ) ✔\ntexcmss computer modern sans serif (Image: ) ✔\ntexcmssb computer modern sans serif bold (Image: ) ✔\ntexcmssi computer modern sans serif italic (Image: ) ✔\ntexcmtt computer modern typewriter (Image: ) ✔\ntexcmitt computer modern italic typewriter (Image: ) ✔\ntexmi  (Image: ) ✔\nplsr  (Image: ) ✔\npldr  (Image: ) ✔\npltr  (Image: ) ✔\nplti  (Image: ) ✔\nplcr  (Image: ) ✔\nplci  (Image: ) ✔\nplss  (Image: ) ✔\nplcs  (Image: ) ✔\nplsa  (Image: ) ✔\nplba  (Image: ) ✔\nplge  (Image: ) ✔\nplgg  (Image: ) ✔\nplgi  (Image: ) ✔\npstr times roman (Image: ) ✘\npstb times bold (Image: ) ✘\npsti times italic (Image: ) ✘\npstbi times bold italic (Image: ) ✘\npsc courier (Image: ) ✘\npscb courier bold (Image: ) ✘\npsco courier oblique (Image: ) ✘\npscbo courier bold oblique (Image: ) ✘\npsh helvetica (Image: ) ✘\npshb helvetica bold (Image: ) ✘\npsho helvetica oblique (Image: ) ✘\npshbo helvetica bold oblique (Image: ) ✘\npshc  (Image: ) ✘\npshcb  (Image: ) ✘\npshcbo  (Image: ) ✘\npshcdo  (Image: ) ✘\npshn helvetica narrow (Image: ) ✘\npshnb helvetica narrow bold (Image: ) ✘\npshno helvetica narrow oblique (Image: ) ✘\npshnbo helvetica narrow oblique bold (Image: ) ✘\npsagb avantgarde book (Image: ) ✘\npsagd avantgardedemi (Image: ) ✘\npsagd avantgardedemi (Image: ) ✘\npsagbo avantgardebook oblique (Image: ) ✘\npsagdo avantgardedemi oblique (Image: ) ✘\npsbl bookman light (Image: ) ✘\npsbd b. demi (Image: ) ✘\npsbli b. light italic (Image: ) ✘\npsbdi b. demi italic (Image: ) ✘\npsncsr newcentury roman (Image: ) ✘\npsncsb newcentury bold (Image: ) ✘\npsncsi newcentury italic (Image: ) ✘\npsncsbi newcentury bold italic (Image: ) ✘\npspr palatino roman (Image: ) ✘\npspb palatino bold (Image: ) ✘\npspi palatino italic (Image: ) ✘\npspbi palatino. bold italic (Image: ) ✘\npszcmi zapfchancery medium italic (Image: ) ✘\narial8 arial (Image: ) ✘\narial8b arial bold (Image: ) ✘\narial8bi arial bold italic (Image: ) ✘\narial8i arial italic (Image: ) ✘\ncour8 courier (Image: ) ✘\ncour8b courier bold (Image: ) ✘\ncour8bi courier bold italic (Image: ) ✘\ncour8i courier italic (Image: ) ✘\ntimes8 times (Image: ) ✘\ntimes8b times bold (Image: ) ✘Symbol fontsID Aliases Looks like SVG\npssym  (Image: ) ✘\nplcg (greek) (Image: ) ✘\nplsg (greek) (Image: ) ✘\nplcc (cyrillic) (Image: ) ✘\npszd zapfchancery demi (Image: ) ✘"
},

{
    "location": "appendix/fonts/#LaTeX-mode-1",
    "page": "Fonts",
    "title": "LaTeX mode",
    "category": "section",
    "text": ""
},

{
    "location": "lib/public/#",
    "page": "Public",
    "title": "Public",
    "category": "page",
    "text": ""
},

{
    "location": "lib/public/#Public-Documentation-1",
    "page": "Public",
    "title": "Public Documentation",
    "category": "section",
    "text": "Documentation for GPlot.jl\'s public interface.See Internal Documentation for internal package docs."
},

{
    "location": "lib/public/#Contents-1",
    "page": "Public",
    "title": "Contents",
    "category": "section",
    "text": "Pages = [\"public.md\"]"
},

{
    "location": "lib/public/#Index-1",
    "page": "Public",
    "title": "Index",
    "category": "section",
    "text": "Pages = [\"public.md\"]"
},

{
    "location": "lib/public/#GPlot.Figure",
    "page": "Public",
    "title": "GPlot.Figure",
    "category": "type",
    "text": "Figure(id; opts...)\n\nReturn a new Figure object with name id, if a figure with that name exists already, return that object.\n\nNamed options:\n\nsize: a tuple (width, height) (for rendering prefer sizes ≥ (8, 8) see also fontsize recommendations)\nfont: a valid font name (note that if you use latex, this is irrelevant)\nfontsize: the master font size of the figure in pt (for rendering, prefer fontsizes ≥ 10pt)\ncol, color: the master font color of the figure (any Colors.Colorant can be used)\ntex, hastex, latex, haslatex: a boolean indicating whether there is LaTeX to be compiled in the figure\ntexscale: either fixed, none or scale to match the size of LaTeX expressions to the ambient fontsize (fixed and scale match, none doesn\'t)\npreamble, texpreamble: the LaTeX preamble, where you can change the font that is used and also make sure that the symbols you want to use are available.\nalpha, transparent, transparency: a bool indicating whether there may be transparent fillings in which case cairo is used\n\nOther options (internal use mostly):\n\nreset: a bool, if true will erase the figure if it exists (instead of just returning it).\n_noreset: internal to indicate that if the figure has no name and is called whether a new one\n\nshould be sent or not (for the user: yes, internally: sometimes not as we want to retrieve properties)\n\n\n\n\n\n"
},

{
    "location": "lib/public/#Internals-1",
    "page": "Public",
    "title": "Internals",
    "category": "section",
    "text": "TBAGPlot.Figure"
},

{
    "location": "lib/internals/#",
    "page": "Internals",
    "title": "Internals",
    "category": "page",
    "text": ""
},

{
    "location": "lib/internals/#Internal-Documentation-1",
    "page": "Internals",
    "title": "Internal Documentation",
    "category": "section",
    "text": "Documentation for GPlot.jl\'s public interface.See Public Documentation for internal package docs."
},

{
    "location": "lib/internals/#Contents-1",
    "page": "Internals",
    "title": "Contents",
    "category": "section",
    "text": "Pages = [\"internals.md\"]"
},

{
    "location": "lib/internals/#Index-1",
    "page": "Internals",
    "title": "Index",
    "category": "section",
    "text": "Pages = [\"internals.md\"]"
},

{
    "location": "lib/internals/#Internals-1",
    "page": "Internals",
    "title": "Internals",
    "category": "section",
    "text": "TBAGPlot.set_color!,\nGPlot.set_colors!,\nGPlot.set_fill!,\nGPlot.set_fills!,\nGPlot.set_alpha!,\nGPlot.set_font!,\nGPlot.set_hei!,\nGPlot.set_lstyle!,\nGPlot.set_lstyles!,\nGPlot.set_lwidth!,\nGPlot.set_lwidths!,\nGPlot.set_smooth!,\nGPlot.set_smooths!,\nGPlot.set_markers!,\nGPlot.set_msizes!,\nGPlot.set_mcols!,\nGPlot.set_mecols!,\nGPlot.set_widths!"
},

]}
