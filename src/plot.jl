function plot(xy::MF, fig=Figure())

    # NOTE axes pick (current axes or new)
    # NOTE smooth pick (and options pick)

    push!(fig.axes, Axes2D())

    ls = LineStyle(
            lstyle = 0,
            smooth = true,
            color  = parse(Colorant, "cornflowerblue")
            )
    m = Markers(
            marker = "fcircle",
            msize  = 0.05,
            color  = parse(Colorant, "indianred")
            )
    line = Line2D(
            xy      = xy,
            lstyle  = ls,
            markers = m
            )

    push!(fig.axes[1].drawings, line)

    return fig
end
