function plot3!(x::AV{<:Real}, y::AV{<:Real}, z::AV{<:Real};
                axes=nothing, overwrite=false, o...)
    # check dimensions
    if !(length(x) == length(y) == length(z))
        throw(DimensionMismatch("x,y and z data must have the same length."))
    end
    d = vcat(x,y,z)
    if any(isnan, d) || any(isinf, d)
        throw(ArgumentError("x,y and z cannot have NaNs or Inf values."))
    end
    axes = check_axes(axes; dims=3)
    if overwrite
        all(isempty, (axes.drawings, axes.objects)) || reset!(axes)
    end

    # force axis limits, this is because GLE has a bug whereby it assumes everything is in the
    # [0,1]x[0,1]x[...] cube and scales thing badly if they're not so in order to scale things
    # correctly, we must know exactly what the axis limits are.
    xmin, xmax = extrema(x)
    ymin, ymax = extrema(y)
    zmin, zmax = extrema(z)
    δx = xmax-xmin
    δy = ymax-ymin
    δz = zmax-zmin
    xmin = xmin - 0.1δx
    xmax = xmax + 0.1δx
    ymin = ymin - 0.1δy
    ymax = ymax + 0.1δy
    zmin = zmin - 0.1δz
    zmax = zmax + 0.1δz
    axes.xaxis.min = rmin(axes.xaxis.min, xmin)
    axes.yaxis.min = rmin(axes.yaxis.min, ymin)
    axes.zaxis.min = rmin(axes.zaxis.min, zmin)
    axes.xaxis.max = rmax(axes.xaxis.max, xmax)
    axes.yaxis.max = rmax(axes.yaxis.max, ymax)
    axes.zaxis.max = rmax(axes.zaxis.max, zmax)

    # add the 3D scatter to the stack
    scatter = Scatter3D(data=zip(x,y,z))
    scatter.linestyle.lstyle = 1
    scatter.markerstyle.marker = "fcircle"
#XXX    set_properties!(scatter; defer_preview=true, o...)
    push!(axes.drawings, scatter)
    return DrawingHandle(scatter)
end

"""
    plot3(...)

Erase previous drawings and add a plot3. See also [`plot3!`](@ref).
"""
plot3(a...; o...) = plot3!(a...; overwrite=true, o...)

"""
    scatter3!(...)

Add a 3D scatter plot (no line joins the points). See also [`plot3!`](@ref).
"""
scatter3!(a...; o...) = plot3!(a...; ls="none", marker=".", o...)

"""
    scatter3(...)

Erase previous drawings and add a 3D scatter plot (no line joins the points). See also [`plot3`](@ref).
"""
scatter3(a...; o...)  = scatter3!(a...; overwrite=true, o...)
