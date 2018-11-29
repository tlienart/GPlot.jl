# Todo

## ongoing

* start systematic testing or it will become a mess very quickly
* make smooth=true default above a given number of points probably as would be expected by user.
* recommendation to have size not too small so that `hei` can be larger than `0.3` otherwise may have issue with the latex looking squeezed

--------

(GLE support first)

## Gen

* [ ] get a better understanding for font sizes and font sizes issues, try to include stuff in latex and see what compares to what.
* [ ] test in `Base.show` that error in latex is displayed if fuckup --> not satisfactory, this may be more tricky. Could stick with the ugly error message for now and maybe work something out later or maybe with `cat` and then a return (problem is that MIME fucks up where things appear.)
* [ ] testing transparency (should be able to import fig in beamer with gray background without whiteout) --> with the `-transparent` and d png should be ok
* [ ] color palette via [colorschemes](https://github.com/JuliaGraphics/ColorSchemes.jl)
* [ ] to avoid ticks names and ticks labels not having the same size, only allow a function with `(ticksplaces, [ticksnames=...])` and not just ticksnames.
* [ ] when tex labels, it may overflow a bit, so need to change the size a bit
* [ ] suppress font setting when texlabels are true (try different settings)
* [ ] ~~BUG texscale is incorrect it should be a string~~. Below seems to be the right approach that actually works, should investigate more.
* [ ] windows testing, will need to replace any forward `/` by joinpath also make sure things like `2>&1` work in shell called from julia on windows. not sure how that works.

```
size 8.0 6.0
!set hei 0.2
!set texlabels 1
set hei 0.1
begin texpreamble
    \usepackage{palatino}
end texpreamble
set texlabels 1 texscale scale
```

* [] latexstrings seems to be pretty slow, maybe could just use raw?

## Output

* [ ] allow specify no background via `-transparent` option and `png` device (see what matplotlib does?)

## 2D

* [ ] [examples from GLE](http://glx.sourceforge.net/examples/2dplots/index.html)
    * [ ] [decay.gle](http://glx.sourceforge.net/examples/2dplots/decay.html)
    * [ ] [quantilescale.gle](http://glx.sourceforge.net/examples/2dplots/quantilescale.html)
* [ ] subplots
* [ ] legend
* [ ] curves
    * [ ] allow strings for marker style [like this](https://matplotlib.org/examples/lines_bars_and_markers/line_styles_reference.html)
    * [ ] automated colour changing when plotting several curves
    * [ ] [area between curve and ax](https://matplotlib.org/examples/lines_bars_and_markers/fill_demo.html) [also this](https://matplotlib.org/examples/lines_bars_and_markers/fill_demo_features.html)
    * [ ] area between curves
    * [ ] [custom markers](https://matplotlib.org/examples/lines_bars_and_markers/line_demo_dash_control.html) also [this](https://matplotlib.org/examples/lines_bars_and_markers/linestyles.html)
* [ ] bar plot
    * [ ] basic bar plot, vertical
    * [ ] basic bar plot, [horizontal](https://matplotlib.org/examples/lines_bars_and_markers/barh_demo.html)
    * [ ] error bars on bar plot
    * [ ] stacked bar plots
    * [ ] histogram with different normalisations
* [ ] boxplot
    * [ ] [basic boxplot](https://matplotlib.org/examples/statistics/boxplot_color_demo.html)
    * [ ] [more advanced boxplot](https://matplotlib.org/examples/statistics/boxplot_demo.html)
* [ ] [cdfplot](https://matplotlib.org/examples/statistics/histogram_demo_cumulative.html)
* [ ] pie plot
* [ ] polar plot
* [ ] reproduce examples from [matplotlib gallery](https://matplotlib.org/gallery.html)

## 3D

* [ ] contour plot

## Integration

* [ ] Dataframe
    * [] [lmplot](https://seaborn.pydata.org/examples/anscombes_quartet.html)


# Gnuplot

## Rough notes

* [ ] centered axis ("math" mode) [here](https://stackoverflow.com/questions/12749661/how-to-move-axes-to-center-of-chart)

## Resources

* gnuplot tricks [here](http://gnuplot-tricks.blogspot.com/)
* more blogging [here](http://gnuplot-surprising.blogspot.com/)
* gnuplot in action [(book)](http://www-bs2.informatik.uni-tuebingen.de/services/nilse/books/GnuplotinAction.pdf) especially the "polishing" section
