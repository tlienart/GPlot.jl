# Todo

## NOW

* legend called multiple times, will duplicate
* more tests for legends, either via label keyword or via construction

### add features

* when reading from file can use `0` to let GLE generate. That's the approach that should be used for like Hist2D from file or Bar from file.

* can use basic Latex without actual tex mode (see appendix A3) for instance sub/super-scripts. This can work fine for a lot of simple things and avoids the overhead of pdflatex. Basically all greek letters, most standard maths ops, should link to extracted page 89 of the manual.

* marker color (proper way) + how to define arbitrary marker

```
size 8 6
set font psh hei 0.35

sub mymarker size mdata
	gsave ! save font and x,y
	set just left font pszd hei size
	set color red
	t$ = "\char{102}"
	rmove -twidth(t$)/2 -theight(t$)/2 ! centers marker
	write t$
	grestore ! restore font and x,y
end sub

defmarker hand pszd 43 1 0 0 ! scale dx dy
define marker weird mymarker

begin graph
	data "dat.dat"
	d1 line color blue
	d1 marker weird
!	d1 marker hand
end graph
```

* hline/vline/line

```
! LINE
amove xg(x1) yg(y1)
aline xg(x2) yg(y2)
```
* text somewhere

```
! TEXT somewhere
amove xg(x)+dx yg(y)+dy
write $something
```

* error bars (there's something in graphutils but?)
* boxplot

```
sub boxplot ds0 bwidth msize
   default ds0 1
   default bwidth 0.4
   default msize 1.5
   set cap round
   for i = 1 to ndata("d"+num$(ds0))
      local x = dataxvalue("d"+num$(ds0), i)
      ! avg min Q.25 Q.5 Q.75 max
      ! 0   1   2    3   4    5
!      local meanv = datayvalue("d"+num$(ds0), i)
!      local minv = datayvalue("d"+num$(ds0+1), i)
!      local q25 = datayvalue("d"+num$(ds0+2), i)
!      local q50 = datayvalue("d"+num$(ds0+3), i)
!      local q75 = datayvalue("d"+num$(ds0+4), i)
!      local maxv = datayvalue("d"+num$(ds0+5), i)
      amove xg(x)-bwidth/2 yg(minv)
      aline xg(x)+bwidth/2 yg(minv)
      amove xg(x) yg(minv)
      aline xg(x) yg(q25)
      amove xg(x)-bwidth/2 yg(q25)
      box bwidth yg(q75)-yg(q25)
      amove xg(x)-bwidth/2 yg(q50)
      aline xg(x)+bwidth/2 yg(q50)
      amove xg(x) yg(q75)
      aline xg(x) yg(maxv)
      amove xg(x)-bwidth/2 yg(maxv)
      aline xg(x)+bwidth/2 yg(maxv)
      amove xg(x) yg(meanv)
      marker fdiamond msize*bwidth
   next i
end sub
```

* pie plot

```
sub pie ang1 ang2 radius colour$
   !
   ! draw pie wedge between ang1 and ang2
   ! radius.... the radius
   ! colour$... the fill color of the wedge
   !
   begin path fill colour$ stroke
   rmove 0 0                       !The rmove command is neccesary to set
   arc radius ang1 ang2            !the beginning of the path
   closepath
   end path
end sub

sub pie_text ang1 ang2 radius colour$ label$
   !sub pie - Subroutine to draw a coloured pie wedge
   !          between two supplied angles
   !          with a key and a label
   ! draw pie wedge between ang1 and ang2
   ! radius.... the radius
   ! colour$... the fill color of the wedge
   ! label$ ... te text you want to display
   !
   gsave
   begin path fill colour$ stroke
   rmove 0 0                 !The rmove command is neccesary to set
   arc radius ang1 ang2      !the beginning of the path
   closepath
   end path

   !
   ! put text in center of pie
   !
   set just cc
   ang = ang1+(ang2-ang1)/2
   rmove (radius/2)*cos(torad(ang)) (radius/2)*sin(torad(ang))
   write label$
   grestore

end sub
```

* recommendation to have size not too small so that `hei` can be larger than `0.35` (~10pt) otherwise may have issue with the latex looking squeezed and funny

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
