####
#### plot, plot!
####

"""
    plot!([axes], xy; options...)
    plot!([axes], x, y; options...)

Add one or several line plots on the current axes.
"""
function plot!(axes::Axes2D{B}
             , xy::MR
             ; overwrite=false
             , opts... ) where B<:Backend

    # if overwrite, destroy axes and start afresh
    overwrite && erase!(axes)

    # create line object, set properties and push to drawing stack
    line = Line2D(xy = xy)

    set_properties!(GLE, line; opts...)
    push!(axes.drawings, line)
    return
end

# if no axes are given (e.g. gca() returned nothing) then add axes and plot
plot!(::Nothing, xy; opts...) = (add_axes2d!(); plot!(gca(), xy; opts...))

function plot!(axes::Option{Axes2D}
             , x::Union{ARR, AVR}
             , y::Union{AVR, MR}
             ; opts...)

    @assert length(x) == size(y, 1) "x and y must have matching dimensions"
    plot!(axes, hcat(x, y); opts...)
    return
end

plot!(y::AVR; opts...) = plot!(gca(), 1:length(y), y; opts...)
plot!(xy::MR; opts...) = plot!(gca(), xy; opts...)
plot!(x::Union{ARR, AVR}, y::Union{AVR, MR}; opts...) = plot!(gca(), x, y; opts...)

###

"""
    plot(xy; options...)
    plot(x, y; options...)

Add one or several line plots on cleaned up axes on the current figure
(deletes any drawing that might be on the axes).
"""
plot(xy::MR; opts...)         = (plot!(gca(), xy;   overwrite=true, opts...))
plot(x::AVR, y::AVR; opts...) = (plot!(gca(), x, y; overwrite=true, opts...))
plot(x::AVR, y::MR; opts...)  = (plot!(gca(), x, y; overwrite=true, opts...))

####
#### legend!, legend
####

"""
    legend!(axes; options...)

Update the properties of an existing legend object present on `axes`. If none
exist then a new one is created with the given properties.
"""
function legend!(axes::Axes2D{B}
               ; overwrite=false
               , opts...) where B<:Backend

    # if there exists a legend object but overwrite, then reset it
    (!isdef(axes.legend) || overwrite) && (axes.legend = Legend())
    set_properties!(B, axes.legend; opts...)
    return
end

"""
    legend(; options...)

Creates a new legend object on the current axes with the given options.
If one already exist, it will be destroyed and replaced by this one.
"""
legend(; opts...) = legend!(gca(); overwrite=true, opts...)
