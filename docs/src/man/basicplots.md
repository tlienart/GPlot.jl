# Basic Plots

## Line and scatter plot

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
