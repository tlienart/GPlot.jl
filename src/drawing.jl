####
#### plot, plot!
####

"""
    plot!(xy; options...)
    plot!(x, y; options...)
    plot!(x, y1, y2, ...; options)

Add one or several line plots on the current axes.
"""
function plot!(a::Option{Axes2D}, xy::AMR; overwrite=false, opts...)
    isdef(a) || (a = add_axes2d!())
    # if overwrite, destroy axes and start afresh
    overwrite && erase!(a)
    # create line object, set properties and push to drawing stack
    line = Scatter2D(xy = xy)
    set_properties!(line; opts...)
    push!(a.drawings, line)
    return a
end

function plot!(a::Option{Axes2D}, x::Union{ARR, AVR}, y::Union{AVR, AMR}; opts...)
    @assert length(x) == size(y, 1) "x and y must have matching dimensions"
    plot!(a, hcat(x, y); opts...)
    return
end

plot!(y::AVR; opts...) = plot!(gca(), 1:length(y), y; opts...)
plot!(xy::AMR; opts...) = plot!(gca(), xy; opts...)

plot!(x::Union{ARR, AVR}, y::Real; opts...)  = plot!(gca(), x, zero(x) .+ y; opts...)
plot!(x::Union{ARR, AVR}, y; opts...)        = plot!(gca(), x, y; opts...)
plot!(x::Union{ARR, AVR}, y, ys...; opts...) = plot!(gca(), hcat(x, y, ys...))

###

"""
    plot(xy; options...)
    plot(x, y; options...)
    plot(x, y1, y2,...; options...)

Add one or several line plots on cleaned up axes on the current figure
(deletes any drawing that might be on the axes).
"""
plot(xy::AMR; opts...)                      = plot!(xy; overwrite=true, opts...)
plot(x::Union{ARR, AVR}, y; opts...)        = plot!(x, y; overwrite=true, opts...)
plot(x::Union{ARR, AVR}, y, ys...; opts...) = plot!(hcat(x, y, ys...); overwrite=true, opts...)

####
#### fill_between!, fill_between
####

function fill_between!(a::Option{Axes2D}, xy1y2::AMR; overwrite=false, opts...)
    isdef(a) || (a = add_axes2d!())
    # if overwrite, destroy axes and start afresh
    overwrite && erase!(a)
    # create fill object, set properties and push to drawing stack
    fill = Fill2D(xy1y2 = xy1y2)
    set_properties!(fill; opts...)
    push!(a.drawings, fill)
    return a
end

function fill_between!(axes::Option{Axes2D}, x::Union{ARR, AVR}, y1::AVR,
                        y2::AVR; opts...)
    @assert length(x) == length(y1) == length(y2) "x, y1, y2 must have the same length"
    fill_between!(axes, hcat(x, y1, y2); opts...)
    return
end

fill_between!(x, y1::Real, y2::AVR; opts...) = fill_between!(gca(), x, zero(x) .+ y1, y2; opts...)
fill_between!(x, y1, y2::Real; opts...)      = fill_between!(gca(), x, y1, zero(x) .+ y2; opts...)
fill_between!(x, y1::AVR, y2::AVR; opts...)  = fill_between!(gca(), x, y1, y2; opts...)

fill_between(x, y1, y2; opts...) = fill_between!(x, y1, y2; overwrite=true, opts...)

####
#### hist, hist!
####

"""
    hist!([axes], x; options...)

Add a histogram of `x` on the current axes.
"""
function hist!(a::Option{Axes2D}, x::AVR; overwrite=false, opts...)
    isdef(a) || (a = add_axes2d!())
    # if overwrite, destroy axes and start afresh
    overwrite && erase!(a)
    # create hist2d object assign properties and push to drawing stack
    hist = Hist2D(x = x)
    set_properties!(hist; opts...)
    push!(a.drawings, hist)
    return a
end

hist!(x::AVR; opts...) = hist!(gca(), x; opts...)

hist(x; opts...)  = hist!(x; overwrite=true, opts...)


####
#### bar!, bar
####

function bar!(a::Option{Axes2D}, xy::AMR; overwrite=false, opts...)
    isdef(a) || (a = add_axes2d!())
    # if overwrite, destroy axes and start afresh
    overwrite && erase!(a)
    # create groupedbar2d object, assign properties and push to drawing stack
    gb = GroupedBar2D(xy = xy, barstyle=[BarStyle() for i ∈ 1:(size(xy,2)-1)])
    set_properties!(gb; opts...)
    push!(a.drawings, gb)
    return a
end

function bar!(axes::Option{Axes2D}, x::Union{ARR, AVR}, y::AMR; opts...)
    @assert length(x) == size(y, 1) "The number of rows in `y` must match the length of `x`"
    bar!(axes, hcat(x, y); opts...)
    return
end

bar!(y::AVR; opts...) = bar!(gca(), hcat(1:length(y), y); opts...)
bar!(x, y::AMR; opts...) = bar!(gca(), x, y; opts...)
bar!(x, y, ys...; opts...) = bar!(gca(), x, hcat(y, ys...); opts...)

bar(y; opts...) = bar!(y; overwrite=true, opts...)
bar(x, y; opts...) = bar!(x, y; overwrite=true, opts...)
bar(x, y, ys...; opts...) = bar!(x, hcat(y, ys...); overwrite=true, opts...)
