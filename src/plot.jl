function plot!(fig::Figure, xy::MF; opt...)

    # NOTE axes pick (current axes or new)

    push!(fig.axes, Axes2D())

    line = Line2D(xy = xy)

    set_properties!(fig.g, line; opt...)

    push!(fig.axes[1].drawings, line)

    return fig
end

plot!(xy::MF; opt...) = plot!(get_curfig(), xy; opt...)

# XXX need check length
plot!(fig::Figure, x::AVF, y::AVF; opt...) = plot!(fig, hcat(x, y); opt...)
plot!(x::AVF, y::AVF; opt...) = plot!(get_curfig(), x, y; opt...)


plot(xy::MF; opt...) = plot!(Figure(), xy; opt...)

# XXX need check length
plot(x::AVF, y::AVF; opt...) = plot(hcat(x, y); opt...)
