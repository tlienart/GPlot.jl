function plot!(axes::Axes2D, xy::MF; opt...)
    line = Line2D(xy = xy)
    set_properties!(fig.g, line; opt...)
    push!(axes.drawings, line)
    return axes
end

function plot!(axes::Axes, x::AVF, y::AVF; opt...)
    @assert length(x) == length(y) "x and y must have the same length"
    plot!(axes, hcat(x, y); opt...)
end

plot!(xy::MF; opt...) = plot!(get_curaxes(), xy; opt...)
plot!(x::AVF, y::AVF; opt...) = plot!(get_curaxes(), x, y; opt...)

plot(xy::MF; opt...) = plot!(Figure(), xy; opt...)

# XXX need check length
plot(x::AVF, y::AVF; opt...) = plot(hcat(x, y); opt...)
