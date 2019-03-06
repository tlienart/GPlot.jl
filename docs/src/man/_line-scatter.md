# Line and scatter plot

## Basic syntax

The relevant commands here are `plot`, `plot!`, `scatter` and `scatter!`.
The key command is a `plot` which is just a 2D line connecting a set of points; where `plot` by default shows a line and no marker, `scatter` by default shows markers and no line.

The general syntax is:

```
command(data_to_plot...; options...)
```

a command *with* an exclamation mark will add the corresponding plot to the current active axes while a command *without* will erase any existing plot on the current active axes and then display the plot.

For instance:

@@CODE:ls_ex1

overlays a scatterplot to a line plot:

@@IMG:ls_ex1

## Data formats

These commands take vectors or matrices of points, as long as the number of rows match you should be fine.

* **Single vector** $x$: the plot will correspond to the pairs $(i, x_i)$.

For instance:

@@CODE:ls_ex2

@@IMG:ls_ex2

* **Two vectors** $x$, $y$: the plot will correspond to the pairs $(x_i, y_i)$ (see e.g. the example earlier)

* **Multiple vectors** $x$, $y$, $z$: this will create multiple plots corresponding to the pairs $(x_i, y_i)$, $(x_i, z_i)$ etc.

For instance:

@@CODE:ls_ex3

@@IMG:ls_ex3

* **Single matrix** $X$: the plots will correspond to the pairs $(i, X_{i1})$, $(i, X_{i2})$ etc.

For instance:

@@CODE:ls_ex4

@@IMG:ls_ex4

* **vector and matrices or vector** $x$, $Y$, $Z$: will form plots corresponding to the pairs of $x$ and each column in $Y$, $Z$ etc.

For instance:

@@CODE:ls_ex5

@@IMG:ls_ex5

## Styling options

Line and scatter plots have effectively two things they can get styled:

1. the line styles
2. the marker styles

Note the plural, so that if you are plotting multiple lines at once, each keyword accepts a vector of elements to style the individual plots.
If a styling option is specified with a scalar but multiple lines are being plotted, all will have that same option.

For instance:

@@CODE:ls_ex6

@@IMG:ls_ex6

### Line style options

For each of these options, it should be understood that you can either pass a single value or a vector of values.

- **line style** [`ls` , `lstyle`, `linestyle`, `lstyles` and `linestyles`]: take a string describing how the line(s) will look like.

| Value    | Result  | Comment
| :------: | :-----: | :-----:
| `"-"`      | ![](../assets/linestyle/ls_-.png)  | default for `plot`
| `"--"`     | ![](../assets/linestyle/ls_--.png) |
| `"-."`     | ![](../assets/linestyle/ls_-..png) |
| `"none"`   |         | default for `scatter`


- **line width** [`lw`, `lwidth`, `linewidth`, `lwidths` and `linewidths`]: take a positive number describing how thick the line should be in centimeters.

| Value    | Result  | Comment
| :------: | :-----: | :-----:
| `0.001`      | ![](../assets/linestyle/lw_0001.png)        |
| `0.01`     |   ![](../assets/linestyle/lw_001.png)      |
| `0.05`     |    ![](../assets/linestyle/lw_005.png)     |
| `0.1 `    |    ![](../assets/linestyle/lw_01.png)     |
| `0 `  |    ![](../assets/linestyle/lw_0.png)     | default value, corresponds to `0.02`

- **line color** [`col`, `color`, `cols` and `colors`]: take a string (most [SVG color name](https://www.december.com/html/spec/colorsvg.html)) or a `Color` object (from the [`Colors.jl`](https://github.com/JuliaGraphics/Colors.jl) package) describing how the line should be coloured.

| Value    | Result  
| :------: | :-----:
| `"cornflowerblue"` | ![](../assets/linestyle/lc_cornflowerblue.png)
| `"forestgreen"` | ![](../assets/linestyle/lc_forestgreen.png)
| `"indigo"` | ![](../assets/linestyle/lc_indigo.png)
| `"RGB(0.5,0.7,0.2)"`   |    ![](../assets/linestyle/lc_rgb050702.png)    

Note that if the colour is not specified, a default colour will be taken by cycling through a colour palette.

- **smoothness**: [`smooth` and `smooths`]: take a boolean indicating whether the line interpolating between the points should be made out of straight lines (default, `smooth=false`) or out of interpolating splines (`smooth=true`). The latter may look nicer for plots that represent a continuous function when there aren't many points.

@@CODE:ls_ex7

@@IMG:ls_ex7

Here's another example combining several options:

@@CODE:ls_ex8

@@IMG:ls_ex8

### Marker style options

## Notes

Infinities, NaNs and Missing values are all treated the same way: they're not shown.

TBD
- plot is tied to data, if data changes, the plot will change too, so should be careful. Note that this is ONLY if the data is modified in place. So for instance

```julia
x = randn(5)
y = randn(5)
plot(x, y)
x = zeros(5)
xlabel("blah") # the graph will not have changed
```

however

```julia
x = randn(5)
y = randn(5)
plot(x, y)
x[1] = 0.0
xlabel("blah") # here the first point will be (0.0, y[1])
```

- Inf, NaN and Missings are all considered in the same way (as missings).

## Bar plot
