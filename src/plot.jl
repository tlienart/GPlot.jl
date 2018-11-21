function plot!(axes::Axes2D{B}, xy::MF; opts...) where B<:Backend
    line = Line2D(xy = xy)
    set_properties!(B, line; opts...)
    push!(axes.drawings, line)
    return axes
end

plot!(::Nothing, xy; opts...) = plot!(add_axes2d!(), xy; opts...)

function plot!(axes::Option{Axes2D}, x::AVF, y::AVF; opts...)
    @assert length(x) == length(y) "x and y must have the same length"
    plot!(axes, hcat(x, y); opts...)
end

plot!(xy::MF; opts...)         = plot!(gca(), xy; opts...)
plot!(x::AVF, y::AVF; opts...) = plot!(gca(), x, y; opts...)

plot(xy::MF; opts...)         = (Figure(); plot!(xy; opts...))
plot(x::AVF, y::AVF; opts...) = (Figure(); plot!(x, y; opts...))
