####
#### plot, plot!
####

"""
    plot!(xy; options...)
    plot!(x, y; options...)
    plot!(x, y1, y2, ...; options)

Add one or several line plots on the current axes.
"""
function plot!(a::Axes2D, xy::Matrix{Float64}; overwrite=false, opts...)
    # if overwrite, destroy axes and start afresh
    overwrite && erase!(a)
    # create scatter object
    s = Scatter2D(xy)
    # if there's more than 20 points, default to smooth
    if size(xy, 1) ≥ 20
        set_properties!(s; smooth=true, opts...)
    else
        set_properties!(s; opts...)
    end
    # push to the drawing stack
    push!(a.drawings, s)
    return a
end
plot!(::Nothing, a...; o...) = plot!(add_axes2d!(), a...; o...)

plot!(y::AVR; opts...)  = plot!(gca(), hcat(fl(1:length(y)), fl(y)); opts...)
plot!(xy::AMR; opts...) = plot!(gca(), fl(xy); opts...)

plot!(x::Union{ARR, AVR}, y::Real; opts...)  = plot!(gca(), fl(hcat(x, fill(y, length(x)))); opts...)
plot!(x::Union{ARR, AVR}, y; opts...)        = plot!(gca(), fl(hcat(x, y)); opts...)
plot!(x::Union{ARR, AVR}, y, ys...; opts...) = plot!(gca(), fl(hcat(x, y, ys...)); opts...)

"""
    plot(xy; options...)
    plot(x, y; options...)
    plot(x, y1, y2,...; options...)

Add one or several line plots on cleaned up axes on the current figure
(deletes any drawing that might be on the axes).
"""
plot(a...; opts...) = plot!(a...; overwrite=true, opts...)

scatter!(a...; o...) = plot!(a...; ls="none", marker="o", o...)
scatter(a...; o...) = plot!(a...; ls="none", marker="o", overwrite=true, o...)


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

fill_between(a...; opts...) = fill_between!(a...; overwrite=true, opts...)

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
    # create Bar2D object, assign properties and push to drawing stack
    bar = Bar2D(xy)
    set_properties!(bar; opts...)
    push!(a.drawings, bar)
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

bar(a...; opts...) =  bar!(a...; overwrite=true, opts...)
