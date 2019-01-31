####
#### plot, plot!
####

"""
    plot!(xy; options...)
    plot!(x, y; options...)
    plot!(x, y1, y2, ...; options)

Add one or several line plots on the current axes.
"""
function plot!(a::Axes2D, xy::MR; overwrite=false, opts...)
    # if overwrite, destroy axes and start afresh
    overwrite && erase!(a)
    # create line object, set properties and push to drawing stack
    line = Line2D(xy = xy)
    set_properties!(line; opts...)
    push!(a.drawings, line)
    return a
end

# if no axes are given (e.g. gca() returned nothing) then add axes and plot
plot!(::Nothing, xy; opts...) = (add_axes2d!(); plot!(gca(), xy; opts...))

function plot!(a::Option{Axes2D}, x::Union{ARR, AVR}, y::Union{AVR, MR};
               opts...)

    @assert length(x) == size(y, 1) "x and y must have matching dimensions"
    plot!(a, hcat(x, y); opts...)
    return
end

plot!(y::AVR; opts...)     = plot!(gca(), 1:length(y), y; opts...)
plot!(xy::MR; opts...)     = plot!(gca(), xy; opts...)
plot!(x, y::Real; opts...) = plot!(gca(), x, zero(x) .+ y; opts...)

plot!(x::Union{ARR, AVR}, y::Union{AVR, MR}; opts...) = plot!(gca(), x, y; opts...)
plot!(x, y, ys...; opts...) = plot!(gca(), hcat(x, y, ys...))

###

"""
    plot(xy; options...)
    plot(x, y; options...)
    plot(x, y1, y2,...; options...)

Add one or several line plots on cleaned up axes on the current figure
(deletes any drawing that might be on the axes).
"""
plot(xy::MR; opts...)      = plot!(xy; overwrite=true, opts...)
plot(x, y; opts...)        = plot!(x, y; overwrite=true, opts...)
plot(x, y, ys...; opts...) = plot!(hcat(x, y, ys...); overwrite=true, opts...)

####
#### fill_between!, fill_between
####

function fill_between!(a::Axes2D, xy1y2::MR; overwrite=false, opts...)
    # if overwrite, destroy axes and start afresh
    overwrite && erase!(a)
    # create fill object, set properties and push to drawing stack
    fill = Fill2D(xy1y2 = xy1y2)
    set_properties!(fill; opts...)
    push!(a.drawings, fill)
    return a
end

fill_between!(::Nothing, xy1y2::MR; opts...) = (add_axes2d!();
    fill_between!(gca(), xy1y2; opts...))

function fill_between!(axes::Option{Axes2D}, x::Union{ARR, AVR}, y1::AVR,
                        y2::AVR; opts...)

    @assert length(x) == length(y1) == length(y2) "x, y1, y2 must have the " *
                                                  "same length"
    fill_between!(axes, hcat(x, y1, y2); opts...)
    return
end

fill_between!(x, y1::Real, y2::AVR; opts...) = fill_between!(gca(), x,
    zero(x) .+ y1, y2; opts...)
fill_between!(x, y1, y2::Real; opts...)      = fill_between!(gca(), x, y1,
    zero(x) .+ y2; opts...)
fill_between!(x, y1::AVR, y2::AVR; opts...)  = fill_between!(gca(), x, y1, y2;
    opts...)

fill_between(x, y1, y2; opts...) = fill_between!(x, y1, y2;
    overwrite=true, opts...)

####
#### hist, hist!
####

"""
    hist!([axes], x; options...)

Add a histogram of `x` on the current axes.
"""
function hist!(a::Axes2D, x::AVR; overwrite=false, opts...)
    # if overwrite, destroy axes and start afresh
    overwrite && erase!(a)
    # create hist2d object assign properties and push to drawing stack
    hist = Hist2D(x = x)
    set_properties!(hist; opts...)
    push!(a.drawings, hist)
    return a
end

hist!(::Nothing, x::AVR; opts...) = (add_axes2d!(); hist!(gca(), x; opts...))
hist!(x::AVR; opts...) = hist!(gca(), x; opts...)

hist(x; opts...)  = hist!(x; overwrite=true, opts...)


####
#### bar!, bar
####

function bar!(a::Axes2D, xy::MR; overwrite=false, opts...)
    # if overwrite, destroy axes and start afresh
    overwrite && erase!(a)
    # create groupedbar2d object, assign properties and push to drawing stack
    gb = GroupedBar2D(xy = xy, barstyle=[BarStyle() for i ∈ 1:(size(xy,2)-1)])
    set_properties!(gb; opts...)
    push!(a.drawings, gb)
    return a
end

bar!(::Nothing, xy::MR; opts...) = (add_axes2d!(); bar!(gca(), xy; opts...))

function bar!(axes::Option{Axes2D}, x::Union{ARR, AVR}, y::MR; opts...)

    @assert length(x) == size(y, 1) "The number of rows in `y` must match " *
                                    "the length of `x`"
    bar!(axes, hcat(x, y); opts...)
    return
end

bar!(y::AVR; opts...) = bar!(gca(), hcat(1:length(y), y); opts...)
bar!(x, y::MR; opts...) = bar!(gca(), x, y; opts...)
bar!(x, y, ys...; opts...) = bar!(gca(), x, hcat(y, ys...))

bar(y; opts...) = bar!(y; overwrite=true, opts...)
bar(x, y; opts...) = bar!(x, y; overwrite=true, opts...)
bar(x, y, ys...; opts...) = bar!(x, hcat(y, ys...); overwrite=true, opts...)
