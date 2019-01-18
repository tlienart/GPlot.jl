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
    set_properties!(B, line; opts...)
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
plot!(x, y::Real; opts...) = plot!(gca(), x, zero(x) .+ y; opts...)
plot!(x, y::Union{AVR, MR}; opts...) = plot!(gca(), x, y; opts...)

###

"""
    plot(xy; options...)
    plot(x, y; options...)

Add one or several line plots on cleaned up axes on the current figure
(deletes any drawing that might be on the axes).
"""
plot(xy::MR; opts...) = plot!(xy; overwrite=true, opts...)
plot(x, y; opts...) = plot!(x, y; overwrite=true, opts...)


####
#### hist, hist!
####

"""
    hist!([axes], x; options...)

Add a histogram of `x` on the current axes.
"""
function hist!(axes::Axes2D{B}
             , x::AVR
             ; overwrite=false
             , opts... ) where B<:Backend

    # if overwrite, destroy axes and start afresh
    overwrite && erase!(axes)

    # create line object, set properties and push to drawing stack
    hist = Hist2D(x = x)

    set_properties!(B, hist; opts...)
    push!(axes.drawings, hist)
    return
end

hist!(::Nothing, x::AVR; opts...) = (add_axes2d!(); hist!(gca(), x; opts...))

hist!(x::AVR; opts...) = hist!(gca(), x; opts...)

hist(x; opts...)  = hist!(x; overwrite=true, opts...)


####
#### fill_between!, fill_between
####

function fill_between!(axes::Axes2D{B}
                     , xy1y2::MR
                     ; overwrite=false
                     , opts... ) where B<:Backend

    # if overwrite, destroy axes and start afresh
    overwrite && erase!(axes)

    # create fill object, set properties and push to drawing stack
    fill = Fill2D(xy1y2 = xy1y2)
    set_properties!(B, fill; opts...)
    push!(axes.drawings, fill)

    return
end

fill_between!(::Nothing, xy1y2::MR; opts...) = (add_axes2d!();
    fill_between!(gca(), xy1y2; opts...))

function fill_between!(axes::Option{Axes2D}
                    , x::Union{ARR, AVR}
                    , y1::AVR
                    , y2::AVR
                    ; opts...)

    @assert length(x) == length(y1) == length(y2) "x, y1, y2 must have the " *
                                                  "same length"
    fill_between!(axes, hcat(x, y1, y2); opts...)
    return
end

fill_between!(x, y1::Real, y2::AVR; opts...) = fill_between!(gca(), x,
    zero(x) .+ y1, y2; opts...)
fill_between!(x, y1, y2::Real; opts...) = fill_between!(gca(), x, y1,
    zero(x) .+ y2; opts...)
fill_between!(x, y1::AVR, y2::AVR; opts...) = fill_between!(gca(), x, y1, y2;
    opts...)

fill_between(x, y1, y2; opts...) = fill_between!(x, y1, y2;
    overwrite=true, opts...)


####
#### bar!, bar
####

function bar!(axes::Axes2D{B}
            , xy::MR
            ; overwrite=false
            , opts... ) where B<:Backend

    # if overwrite, destroy axes and start afresh
    overwrite && erase!(axes)

    # if there's more than two columns, it's a groupedbar
    obj = Bar2D(xy = xy[:, 1:2])
    if size(xy, 2) > 2
        additional_bars = [Bar2D(xy = xy[:, 1:c]) for c ∈ 3:size(xy, 2)]
        obj = GroupedBars(bars=[obj, additional_bars...])
    end

    # assign properties and push to drawing stack
    set_properties!(B, obj; opts...)
    push!(axes.drawings, obj)

    return
end

bar!(::Nothing, xy::MR; opts...) = (add_axes2d!(); bar!(gca(), xy; opts...))

function bar!(axes::Option{Axes2D}
            , x::Union{ARR, AVR}
            , y::MR
            ; opts...)

    @assert length(x) == size(y, 1) "The number of rows in `y` must match " *
                                    "the length of `x`"
    bar!(axes, hcat(x, y); opts...)
    return
end

bar!(y::AVR; opts...) = bar!(gca(), hcat(1:length(y), y); opts...)
bar!(x, y::MR; opts...) = bar!(gca(), x, y; opts...)

bar(y; opts...) = bar!(y; overwrite=true, opts...)
bar(x, y; opts...) = bar!(x, y; overwrite=true, opts...)
