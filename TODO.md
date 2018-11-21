# Todo

## ongoing

* start systematic testing or it will become a mess very quickly

--------

(GLE support first)

## Gen

* [ ] testing transparency (should be able to import fig in beamer with gray background without whiteout)
* [ ] color palette via [colorschemes](https://github.com/JuliaGraphics/ColorSchemes.jl)
* [ ] to avoid ticks names and ticks labels not having the same size, only allow a function with `(ticksplaces, [ticksnames=...])` and not just ticksnames.


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
