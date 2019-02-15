####
#### plot, plot!
####

"""
    plot!(xy; options...)
    plot!(x, y; options...)
    plot!(x, y1, y2, ...; options...)

Add one or several line plots on the current axes.
"""
function plot!(a::Axes2D, xy::Matrix{<:CanMiss{Float64}}; overwrite=false, o...)
    # if overwrite, destroy axes and start afresh
    overwrite && erase!(a)
    # create scatter object
    s = Scatter2D(xy)
    # if there's more than 20 points, default to smooth
    if size(xy, 1) ≥ 20
        set_properties!(s; smooth=true, o...)
    else
        set_properties!(s; o...)
    end
    # push to the drawing stack
    push!(a.drawings, s)
    return a
end
plot!(::Nothing, a...; o...) = plot!(add_axes2d!(), a...; o...)

plot!(y::AV; o...)  = plot!(gca(), fl(hcat(1:length(y), y)); o...)
plot!(xy::AM; o...) = plot!(gca(), fl(xy); o...)

plot!(x::AV, y::Real; o...) = plot!(gca(), fl(hcat(x, fill(y, length(x)))); o...)
plot!(x::AV, y::AVM; o...)  = plot!(gca(), fl(hcat(x, y)); o...)
plot!(x::AV, y::AVM, ys...; o...) = plot!(gca(), fl(hcat(x, y, ys...)); o...)

"""
    plot(xy; options...)
    plot(x, y; options...)
    plot(x, y1, y2,...; options...)

Add one or several line plots on cleaned up axes on the current figure
(deletes any drawing that might be on the axes).
"""
plot(a...; o...) = plot!(a...; overwrite=true, o...)

scatter!(a...; o...) = plot!(a...; ls="none", marker="o", o...)
scatter(a...; o...)  = plot!(a...; ls="none", marker="o", overwrite=true, o...)


####
#### fill_between!, fill_between
####

function fill_between!(a::Axes2D, xy1y2::Matrix{Float64}; overwrite=false, o...)
    # if overwrite, destroy axes and start afresh
    overwrite && erase!(a)
    # create fill object, set properties and push to drawing stack
    fill = Fill2D(xy1y2 = xy1y2)
    set_properties!(fill; o...)
    push!(a.drawings, fill)
    return a
end
fill_between!(::Nothing, a...; o...) = fill_between!(add_axes2d!(), a...; o...)

# Note these are type as AVR because we don't allow missings here
fill_between!(x::AVR, y1::Real, y2::Real; o...) =
    fill_between!(gca(),fl(hcat(x, zero(x).+y1, zero(x).+y2)); o...)
fill_between!(x::AVR, y1::Real, y2::AVR; o...) =
    fill_between!(gca(),fl(hcat(x, zero(x).+y1, y2)); o...)
fill_between!(x::AVR, y1::AVR, y2::Real; o...) =
    fill_between!(gca(), fl(hcat(x, y1, zero(x) .+ y2)); o...)
fill_between!(x::AVR, y1::AVR, y2::AVR; o...) =
    fill_between!(gca(), fl(hcat(x, y1, y2)); o...)

fill_between(a...; o...) = fill_between!(a...; overwrite=true, o...)

####
#### hist, hist!
####

"""
    hist!([axes], x; options...)

Add a histogram of `x` on the current axes.
"""
function hist!(a::Axes2D, x::Vector{<:CanMiss{Float64}}; overwrite=false, o...)
    # if overwrite, destroy axes and start afresh
    overwrite && erase!(a)
    # create hist2d object assign properties and push to drawing stack
    hist = Hist2D(x = x)
    set_properties!(hist; o...)
    push!(a.drawings, hist)
    return a
end
hist!(::Nothing, a...; o...) = hist!(add_axes2d!(), a...; o...)

hist!(x::AV; o...) = hist!(gca(), fl(x); o...)

hist(x::AV; o...)  = hist!(fl(x); overwrite=true, o...)

####
#### bar!, bar
####

function bar!(a::Axes2D, xy::Matrix{Float64}; overwrite=false, o...)
    # if overwrite, destroy axes and start afresh
    overwrite && erase!(a)
    # create Bar2D object, assign properties and push to drawing stack
    bar = Bar2D(xy)
    set_properties!(bar; o...)
    push!(a.drawings, bar)
    return a
end
bar!(::Nothing, a...; o...) = bar!(add_axes2d!(), a...; o...)

bar!(y::AVM; o...) = bar!(gca(), fl(hcat(1:size(y, 1), y)); o...)
bar!(x::AV, y::AVM; o...) = bar!(gca(), fl(hcat(x, y)); o...)
bar!(x::AV, y::AVM, ys...; o...) = bar!(gca(), fl(hcat(x, y, ys...)); o...)

bar(a...; o...) =  bar!(a...; overwrite=true, o...)
