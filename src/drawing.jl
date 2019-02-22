####
#### plot, plot!
####

"""
    plot!(...)

Add a plot. Keyword arguments can be passed to specify the linestyle(s), label(s) and
markerstyle(s).

## Example

```julia
x = range(-2, 2, length=100)
y = @. exp(-abs(x)+sin(x))
plot(x, y, color="blue", lstyle="--", marker="o", lwidth=0.05, label="First plot")
```
"""
function plot!(a::Axes2D, z::Base.Iterators.Zip, hasmissing::Bool, nobj::Int;
                overwrite=false, o...)::Option{PreviewFigure}
    overwrite && erase!(a)
    s = Scatter2D(z, hasmissing, nobj)
    set_properties!(s; defer_preview=true, o...)
    push!(a.drawings, s)
    return _preview()
end
plot!(::Nothing, a...; o...) = plot!(add_axes2d!(), a...; o...)
plot!(x::AV{<:CanMiss{<:Real}}, y::AVM{<:CanMiss{<:Real}}, ys...; o...) =
    plot!(gca(), pzip(x, hcat(y, ys...))...; o...)
plot!(y::AVM{<:CanMiss{<:Real}}; o...) = plot!(gca(), pzip(y)...; o...)

"""
    plot(...)

Erase previous drawings and add a plot. See also [`plot!`](@ref).
"""
plot(a...; o...) = plot!(a...; overwrite=true, o...)

"""
    scatter!(...)

Add a scatter plot (no line joins the points). See also [`plot!`](@ref).
"""
scatter!(a...; o...) = plot!(a...; ls="none", marker="o", o...)

"""
    scatter(...)

Erase previous drawings and add a scatter plot (no line joins the points). See also [`plot`](@ref).
"""
scatter(a...; o...)  = plot!(a...; ls="none", marker="o", overwrite=true, o...)

####
#### line, line!
####

"""
    line!(from, to; options)

Add a line from `from` (in `[x, y]` format) to `to` (same format). For instance
```julia
line!([0, 0], [1, 1]; ls="--")
```
"""
line!(a::AVR, b::AVR; o...) = plot!([a[1],b[1]], [a[2],b[2]]; o...)

"""
    line(from, to; options)

Erase previous drawings and add a line. See also [`line!`](@ref).
"""
line(a...; o...)  = line!(a...; overwrite=true, o...)

####
#### fill_between!, fill_between
####

function fill_between!(a::Axes2D, z::Base.Iterators.Zip;
                       overwrite=false, o...)::Option{PreviewFigure}
    overwrite && erase!(a)
    fill = Fill2D(z)
    set_properties!(fill; defer_preview=true, o...)
    push!(a.drawings, fill)
    return _preview()
end
fill_between!(::Nothing, a...; o...) = fill_between!(add_axes2d!(), a...; o...)

# Note these are type as AVR because we don't allow missings here
fill_between!(x::AVR, y1::Union{Real,AVR}, y2::Union{Real,AVR}; o...) =
    fill_between!(gca(), fzip(x, y1, y2); o...)

fill_between(a...; o...) = fill_between!(a...; overwrite=true, o...)

####
#### hist, hist!
####

"""
    hist!([axes], x; options...)

Add a histogram of `x` on the current axes.
"""
function hist!(a::Axes2D, z::Base.Iterators.Zip, hasmissing::Bool, nobs::Int, range::T2F;
               overwrite=false, o...)::Option{PreviewFigure}
    overwrite && erase!(a)
    hist = Hist2D(z, hasmissing, nobs, range)
    set_properties!(hist; defer_preview=true, o...)
    push!(a.drawings, hist)
    return _preview()
end
hist!(::Nothing, a...; o...) = hist!(add_axes2d!(), a...; o...)

hist!(x::AV{<:CanMiss{<:Real}}; o...) = hist!(gca(), hzip(x)...; o...)

hist(a...; o...)  = hist!(a...; overwrite=true, o...)

####
#### bar!, bar
####

function bar!(a::Axes2D, z::Base.Iterators.Zip, hasmissing::Bool, nobj::Int;
              overwrite=false, o...)::Option{PreviewFigure}
    overwrite && erase!(a)
    bar = Bar2D(z, hasmissing, nobj)
    set_properties!(bar; defer_preview=true, o...)
    push!(a.drawings, bar)
    return _preview()
end
bar!(::Nothing, a...; o...) = bar!(add_axes2d!(), a...; o...)

bar!(y::AVM; o...) = bar!(gca(), pzip(y)...; o...)
bar!(x::AV, y::AVM, ys...; o...) = bar!(gca(), pzip(x, hcat(y, ys...))...; o...)

bar(a...; o...) =  bar!(a...; overwrite=true, o...)
