####
#### plot, plot!
####

"""
    plot!(xy; options...)
    plot!(x, y; options...)
    plot!(x, y1, y2, ...; options)

Add one or several line plots on the current axes.
"""
function plot!(axes::Axes2D{B}, xy::MR; overwrite=false, opts...
               ) where B<:Backend

    # if overwrite, destroy axes and start afresh
    overwrite && erase!(axes)

    # create line object, set properties and push to drawing stack
    line = Line2D(xy = xy)
    set_properties!(B, line; opts...)
    push!(axes.drawings, line)

    return
end

# if no axes are given (e.g. gca() returned nothing) then add axes and plot
@inline plot!(::Nothing, xy; opts...) = (add_axes2d!(); plot!(gca(), xy; opts...))

function plot!(axes::Option{Axes2D}, x::Union{ARR, AVR}, y::Union{AVR, MR};
               opts...)

    @assert length(x) == size(y, 1) "x and y must have matching dimensions"
    plot!(axes, hcat(x, y); opts...)
    return
end

@inline plot!(y::AVR; opts...)     = plot!(gca(), 1:length(y), y; opts...)
@inline plot!(xy::MR; opts...)     = plot!(gca(), xy; opts...)
@inline plot!(x, y::Real; opts...) = plot!(gca(), x, zero(x) .+ y; opts...)

@inline plot!(x::Union{ARR, AVR}, y::Union{AVR, MR}; opts...) = plot!(gca(), x, y; opts...)
@inline plot!(x, y, ys...; opts...) = plot!(gca(), hcat(x, y, ys...))

###

"""
    plot(xy; options...)
    plot(x, y; options...)
    plot(x, y1, y2,...; options...)

Add one or several line plots on cleaned up axes on the current figure
(deletes any drawing that might be on the axes).
"""
@inline plot(xy::MR; opts...)      = plot!(xy; overwrite=true, opts...)
@inline plot(x, y; opts...)        = plot!(x, y; overwrite=true, opts...)
@inline plot(x, y, ys...; opts...) = plot!(hcat(x, y, ys...); overwrite=true, opts...)

####
#### fill_between!, fill_between
####

function fill_between!(axes::Axes2D{B}, xy1y2::MR; overwrite=false, opts...
                       ) where B<:Backend

    # if overwrite, destroy axes and start afresh
    overwrite && erase!(axes)
    # create fill object, set properties and push to drawing stack
    fill = Fill2D(xy1y2 = xy1y2)
    set_properties!(B, fill; opts...)
    push!(axes.drawings, fill)
    return
end

@inline fill_between!(::Nothing, xy1y2::MR; opts...) = (add_axes2d!();
    fill_between!(gca(), xy1y2; opts...))

function fill_between!(axes::Option{Axes2D}, x::Union{ARR, AVR}, y1::AVR,
                        y2::AVR; opts...)

    @assert length(x) == length(y1) == length(y2) "x, y1, y2 must have the " *
                                                  "same length"
    fill_between!(axes, hcat(x, y1, y2); opts...)
    return
end

@inline fill_between!(x, y1::Real, y2::AVR; opts...) = fill_between!(gca(), x,
    zero(x) .+ y1, y2; opts...)
@inline fill_between!(x, y1, y2::Real; opts...)      = fill_between!(gca(), x, y1,
    zero(x) .+ y2; opts...)
@inline fill_between!(x, y1::AVR, y2::AVR; opts...)  = fill_between!(gca(), x, y1, y2;
    opts...)

@inline fill_between(x, y1, y2; opts...) = fill_between!(x, y1, y2;
    overwrite=true, opts...)

####
#### hist, hist!
####

"""
    hist!([axes], x; options...)

Add a histogram of `x` on the current axes.
"""
function hist!(axes::Axes2D{B}, x::AVR; overwrite=false, opts...
               ) where B<:Backend

    # if overwrite, destroy axes and start afresh
    overwrite && erase!(axes)
    # create hist2d object assign properties and push to drawing stack
    hist = Hist2D(x = x)
    set_properties!(B, hist; opts...)
    push!(axes.drawings, hist)
    return
end

@inline hist!(::Nothing, x::AVR; opts...) = (add_axes2d!(); hist!(gca(), x; opts...))
@inline hist!(x::AVR; opts...) = hist!(gca(), x; opts...)

@inline hist(x; opts...)  = hist!(x; overwrite=true, opts...)


####
#### bar!, bar
####

function bar!(axes::Axes2D{B}, xy::MR; overwrite=false, opts...
              ) where B<:Backend

    # if overwrite, destroy axes and start afresh
    overwrite && erase!(axes)
    # create groupedbar2d object, assign properties and push to drawing stack
    gb = GroupedBar2D(xy = xy, barstyle=[BarStyle() for i ∈ 1:(size(xy,2)-1)])
    set_properties!(B, gb; opts...)
    push!(axes.drawings, gb)
    return
end

@inline bar!(::Nothing, xy::MR; opts...) = (add_axes2d!(); bar!(gca(), xy; opts...))

function bar!(axes::Option{Axes2D}, x::Union{ARR, AVR}, y::MR; opts...)

    @assert length(x) == size(y, 1) "The number of rows in `y` must match " *
                                    "the length of `x`"
    bar!(axes, hcat(x, y); opts...)
    return
end

@inline bar!(y::AVR; opts...) = bar!(gca(), hcat(1:length(y), y); opts...)
@inline bar!(x, y::MR; opts...) = bar!(gca(), x, y; opts...)
@inline bar!(x, y, ys...; opts...) = bar!(gca(), x, hcat(y, ys...))

@inline bar(y; opts...) = bar!(y; overwrite=true, opts...)
@inline bar(x, y; opts...) = bar!(x, y; overwrite=true, opts...)
@inline bar(x, y, ys...; opts...) = bar!(x, hcat(y, ys...); overwrite=true, opts...)
