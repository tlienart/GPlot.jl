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
    "text": "#=\nTodo:\n- work out how to have syntax highlighting\n\n- Appendix/fonts\n  - link to tug.dk font catalogue, suggest the ones that work with pdflatex\n=#"
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
    "text": "TBA"
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
    "text": "Once both GLE and GPlot are successfully installed, this short tutorial should give a feeling for how things work; for more detailed instructions refer to the rest of the manual. We will draw a simple plot with two curves, labels, and basic axis styling.Let\'s start by creating a simple figurefig = Figure()Note: it is not required to explicitly call Figure(); if there no figure exists, the first plotting command will generate one with default parameters.Let\'s now define a simple function which we would like to plot over the range [-2.5, 2.5]:f1(x) = exp(-x^2) * sin(x)\nx = range(-2.5, stop=2.5, length=100)\n\nplot(x, f1.(x))where we\'ve used the . to broadcast the function over the range of values. In order to see what this looks like, you can callpreview()which will show the current figure:(Image: )Let\'s add another curve on this and change the colour. Let\'s also specify where the ticks have to be, add a legend, etc.f2(x) = sin(x^2) * exp(-x/10)\n\nplot!(x, f2.(x), col=\"blue\", lwidth=0.3)\n\nxlabel(\"x-axis\")\nylabel(\"y-axis\")\nxticks([-pi/2, 0, pi/2], [\"π/2\", \"0\", \"π/2\"])\nylim(-0.5, 0.5)\nyticks(-0.5:0.25:0.5)One thing worth noting at this point is that we follow the julia Plots convention adding an ! after plot to indicate that it should modify the current graph without overwriting it (i.e. the curve is added on top of the existing one).Let\'s preview this againpreview()(Image: )We won\'t go much further in this quickstart, hopefully by now you should see that the syntax is heavily inspired from Matplotlib. One last thing is to save the figure we\'ve just so defined.savefig(fig, \"my_first_figure.pdf\")"
},

{
    "location": "man/basicplots/#",
    "page": "Basic 2D plots",
    "title": "Basic 2D plots",
    "category": "page",
    "text": ""
},

{
    "location": "man/basicplots/#Basic-Plots-1",
    "page": "Basic 2D plots",
    "title": "Basic Plots",
    "category": "section",
    "text": ""
},

{
    "location": "man/basicplots/#Line-and-scatter-plot-1",
    "page": "Basic 2D plots",
    "title": "Line and scatter plot",
    "category": "section",
    "text": ""
},

{
    "location": "man/basicplots/#Bar-plot-1",
    "page": "Basic 2D plots",
    "title": "Bar plot",
    "category": "section",
    "text": ""
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
    "text": ""
},

{
    "location": "man/styling/#Axes-and-Axis-1",
    "page": "Styling",
    "title": "Axes and Axis",
    "category": "section",
    "text": "TBD:note that x2axis/y2axis revert to xaxis/yaxis (GLE restriction)\ncannot have xaxis off and x2axis on, same for y\nif xticks happens after grid it will disable, should use xticks! if want to change position\nticks angle are in degrees, rotation is clockwise (e.g. 45)"
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
    "text": "The parent font of the figure can be defined by passing it as argument to the constructor Figure(font=...). In non-LaTeX mode, different fonts can be selected for sub-elements (e.g. axis label); otherwise the parent font is used throughout."
},

{
    "location": "man/styling/#Non-LaTeX-mode-1",
    "page": "Styling",
    "title": "Non-LaTeX mode",
    "category": "section",
    "text": "In non-tex mode, a number of fonts and font-variants are supported, see the appendix for the full list.The table below is a subset of the supported fonts that are likely to be among the most useful. Note that not all fonts are supported for the SVG output.You can specify the font you want using its ID or its name (replacing spaces by dashes) for instance:f = Figure(font=\"texmr\")\nf2 = Figure(font=\"computer-modern-roman\")are both valid way of defining the parent font.Note 1: most fonts only have basic symbol support (typically Greek letters are fine) but will fail for more \"exotic\" symbols like ∫ or ∞. Use the  LaTeX mode for those. Note 2: the fonts that start with tex are tex-like fonts but do not switch on the LaTeX mode.ID Name Looks like SVG\npsh helvetica (Image: ) ✘\npspr palatino roman (Image: ) ✘\ntexcmr computer modern roman (Image: ) ✔\ntexcmss computer modern sans serif (Image: ) ✔\ntexcmtt computer modern sans serif (Image: ) ✔\narial8 arial (Image: ) ✘\nrm roman (Image: ) ✘\nss sans serif (Image: ) ✘\ntt typewriter (Image: ) ✘"
},

{
    "location": "man/styling/#LaTeX-mode-1",
    "page": "Styling",
    "title": "LaTeX mode",
    "category": "section",
    "text": "In LaTeX mode, you\'re free to specify your own preamble which can include font packages to define how things should look. Anything that works with PdfLaTeX should work. Below is an example where we use sourcesanspro:preamble = texpreamble = tex\"\"\"\n    \\usepackage[T1]{fontenc}\n    \\usepackage[default]{sourcesanspro}\n    \\usepackage{amssymb}\n\"\"\"\nf = Figure(texpreamble=preamble)Note: specifying a tex preamble is sufficient to switch to LaTeX mode."
},

{
    "location": "man/advancedplots/#",
    "page": "Advanced plots",
    "title": "Advanced plots",
    "category": "page",
    "text": ""
},

{
    "location": "man/advancedplots/#Advanced-Plots-1",
    "page": "Advanced plots",
    "title": "Advanced Plots",
    "category": "section",
    "text": "TBA"
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
    "text": "The list below shows what these fonts look like and whether SVG output is supported.ID Aliases Looks like SVG\nrm roman (Image: ) ✘\nrmb roman bold (Image: ) ✘\nrmi roman italic (Image: ) ✘\nss sans serif (Image: ) ✘\nssb sans serif bold (Image: ) ✘\nssi sans serif italic (Image: ) ✘\ntt typewriter (Image: ) ✘\nttb typewriter bold (Image: ) ✘\nttbi typewriter bold italic (Image: ) ✘\ntti sans serif (Image: ) ✘\ntexcmr computer modern roman (Image: ) ✔\ntexcmb computer modern bold (Image: ) ✔\ntexcmti computer modern text italic (Image: ) ✔\ntexcmmi computer modern maths italic (Image: ) ✔\ntexcmss computer modern sans serif (Image: ) ✔\ntexcmssb computer modern sans serif bold (Image: ) ✔\ntexcmssi computer modern sans serif italic (Image: ) ✔\ntexcmtt computer modern typewriter (Image: ) ✔\ntexcmitt computer modern italic typewriter (Image: ) ✔\ntexmi  (Image: ) ✔\nplsr  (Image: ) ✔\npldr  (Image: ) ✔\npltr  (Image: ) ✔\nplti  (Image: ) ✔\nplcr  (Image: ) ✔\nplci  (Image: ) ✔\nplss  (Image: ) ✔\nplcs  (Image: ) ✔\nplsa  (Image: ) ✔\nplba  (Image: ) ✔\nplge  (Image: ) ✔\nplgg  (Image: ) ✔\nplgi  (Image: ) ✔\npstr times roman (Image: ) ✘\npstb times bold (Image: ) ✘\npsti times italic (Image: ) ✘\npstbi times bold italic (Image: ) ✘\npsc courier (Image: ) ✘\npscb courier bold (Image: ) ✘\npsco courier oblique (Image: ) ✘\npscbo courier bold oblique (Image: ) ✘\npsh helvetica (Image: ) ✘\npshb helvetica bold (Image: ) ✘\npsho helvetica oblique (Image: ) ✘\npshbo helvetica bold oblique (Image: ) ✘\npshc  (Image: ) ✘\npshcb  (Image: ) ✘\npshcbo  (Image: ) ✘\npshcdo  (Image: ) ✘\npshn helvetica narrow (Image: ) ✘\npshnb helvetica narrow bold (Image: ) ✘\npshno helvetica narrow oblique (Image: ) ✘\npshnbo helvetica narrow oblique bold (Image: ) ✘\npsagb avantgarde book (Image: ) ✘\npsagd avantgardedemi (Image: ) ✘\npsagd avantgardedemi (Image: ) ✘\npsagbo avantgardebook oblique (Image: ) ✘\npsagdo avantgardedemi oblique (Image: ) ✘\npsbl bookman light (Image: ) ✘\npsbd b. demi (Image: ) ✘\npsbli b. light italic (Image: ) ✘\npsbdi b. demi italic (Image: ) ✘\npsncsr newcentury roman (Image: ) ✘\npsncsb newcentury bold (Image: ) ✘\npsncsi newcentury italic (Image: ) ✘\npsncsbi newcentury bold italic (Image: ) ✘\npspr palatino roman (Image: ) ✘\npspb palatino bold (Image: ) ✘\npspi palatino italic (Image: ) ✘\npspbi palatino. bold italic (Image: ) ✘\npszcmi zapfchancery medium italic (Image: ) ✘\narial8 arial (Image: ) ✘\narial8b arial bold (Image: ) ✘\narial8bi arial bold italic (Image: ) ✘\narial8i arial italic (Image: ) ✘\ncour8 courier (Image: ) ✘\ncour8b courier bold (Image: ) ✘\ncour8bi courier bold italic (Image: ) ✘\ncour8i courier italic (Image: ) ✘\ntimes8 times (Image: ) ✘\ntimes8b times bold (Image: ) ✘Symbol fontsID Aliases Looks like SVG\npssym  (Image: ) ✘\nplcg (greek) (Image: ) ✘\nplsg (greek) (Image: ) ✘\nplcc (cyrillic) (Image: ) ✘\npszd zapfchancery demi (Image: ) ✘"
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
    "text": "Figure(id; opts...)\n\nReturn a new Figure object with name id, if a figure with that name exists already, return that object.\n\nNamed options:\n\nsize: a tuple (width, height) (for rendering prefer sizes ≥ (8, 8) see also fontsize recommendations)\nfont: a valid font name (note that if you use latex, this is irrelevant)\nfontsize: the master font size of the figure in pt (for rendering, prefer fontsizes ≥ 10pt)\ncol, color: the master font color of the figure (any Colors.Colorant can be used)\ntex, hastex, latex, haslatex: a boolean indicating whether there is LaTeX to be compiled in the figure\ntexscale: either fixed, none or scale to match the size of LaTeX expressions to the ambient fontsize (fixed and scale match, none doesn\'t)\npreamble, texpreamble: the LaTeX preamble, where you can change the font that is used and also make sure that the symbols you want to use are available.\nalpha, transparent, transparency: a bool indicating whether there may be transparent fillings in which case cairo is used\n\nOther options (internal use mostly):\n\nreset: a bool, if true will erase the figure if it exists (instead of just returning it).\n\n\n\n\n\n"
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
