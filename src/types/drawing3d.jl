# NOTE missing inf or nan NOT allowed
# NOTE one at a time, syntax for multiple would be confusing
@with_kw mutable struct Scatter3D{T} <: Drawing3D
    data       ::T  # data container
    linestyle  ::LineStyle   = LineStyle()   # line style (color, width, ...)
    markerstyle::MarkerStyle = MarkerStyle() # marker style (color, size, ...)
    label      ::String      = ""            # plot labels (to go in the legend)
end



mutable struct Surface <: Drawing3D

end
