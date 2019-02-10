# Quickstart

Once both GLE and GPlot are successfully installed, this short tutorial should give a feeling for how things work; for more detailed instructions refer to the rest of the manual.
We will draw a simple plot with two curves, labels, and basic axis styling.

Let's start by creating a simple figure

```julia
fig = Figure()
```

**Note**: it is not required to explicitly call `Figure()`; if there no figure exists, the first plotting command will generate one with default parameters.

Let's now define a simple function which we would like to plot over the range `[-2.5, 2.5]`:

```julia
f1(x) = exp(-x^2) * sin(x)
x = range(-2.5, stop=2.5, length=100)

plot(x, f1.(x))
```

where we've used the `.` to broadcast the function over the range of values.
In order to see what this looks like, you can call

```julia
preview()
```

which will show the current figure:

![](/assets/quickstart/step1.svg)

Let's add another curve on this and change the colour.
Let's also specify where the ticks have to be, add a legend, etc.

```julia
f2(x) = sin(x^2) * exp(-x/10)

plot!(x, f2.(x), col="blue", lwidth=0.3)

xlabel("x-axis")
ylabel("y-axis")
xticks([-pi/2, 0, pi/2], ["π/2", "0", "π/2"])
ylim(-0.5, 0.5)
yticks(-0.5:0.25:0.5)
```

One thing worth noting at this point is that we follow the julia Plots convention adding an `!` after `plot` to indicate that it should modify the current graph without overwriting it (i.e. the curve is added on top of the existing one).

Let's preview this again

```julia
preview()
```

![](/assets/quickstart/step2.svg)

We won't go much further in this quickstart, hopefully by now you should see that the syntax is heavily inspired from Matplotlib.
One last thing is to save the figure we've just so defined.

```julia
savefig(fig, "my_first_figure.pdf")
```
