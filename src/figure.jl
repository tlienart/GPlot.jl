"""
    Figure(id; opts...)

Return a new `Figure` object with name `id`, if a figure with that name
exists already, return that object.

# Named options:

* `size`: a tuple (width, height) (for rendering prefer sizes ≥ (8, 8) see also fontsize recommendations)
* `font`: a valid font name (note that if you use latex, this is irrelevant)
* `fontsize`: the master font size of the figure in pt (for rendering, prefer fontsizes ≥ 10pt)
* `col`, `color`: the master font color of the figure (any Colors.Colorant can be used)
* `tex`, `hastex`, `latex`, `haslatex`: a boolean indicating whether there is LaTeX to be compiled in the figure
* `texscale`: either `fixed`, `none` or `scale` to match the size of LaTeX expressions to the ambient fontsize (`fixed` and `scale` match, `none` doesn't)
* `preamble`, `texpreamble`: the LaTeX preamble, where you can change the font that is used and also make sure that the symbols you want to use are available.
* `alpha`, `transparent`, `transparency`: a bool indicating whether there may be transparent fillings in which case cairo is used
"""
function Figure(id::String, g::Backend; opts...)

    f = Figure(id, g, Vector{Axes{typeof(g)}}(),
               (12., 9.), TextStyle(hei=0.35), ∅, ∅, ∅, ∅)

    set_properties!(f; opts...)
    GP_ENV["ALLFIGS"][id] = f
    GP_ENV["CURFIG"]      = f
    GP_ENV["CURAXES"]     = nothing
    return f
end

function Figure(id::String="_fig_"; reset=false, opts...)

    id == "_fig_" && return Figure(id, GP_ENV["BACKEND"](); opts...) # fresh
    f = get(GP_ENV["ALLFIGS"], id) do
        Figure(id, GP_ENV["BACKEND"](); opts...)
    end
    reset && erase!(f)
    GP_ENV["CURFIG"]  = f
    GP_ENV["CURAXES"] = isempty(f.axes) ? nothing : f.axes[1]
    set_properties!(f; opts...) # f exists but properties have been given
    return f
end


"""
    add_axes!(fig, ax)

Add axes `ax` to figure `fig`.
"""
function add_axes!(f::Figure, ax::Axes)
    push!(f.axes, ax)
    GP_ENV["CURAXES"] = ax
    return ax
end

"""
    add_axes2d!()

Add empty `Axes2D` to the current figure.
"""
add_axes2d!() = (f=gcf(); B=get_backend(f); add_axes!(f, Axes2D{B}()))


"""
    erase!(fig)

Replaces `fig`'s current axes by a fresh, empty axes container. Note that
other properties of the figure are preserved (such as its size, latex
properties etc).
"""
function erase!(f::Figure)
    # empty associated buffer
    take!(f.g)
    # give `f` a fresh set of axes
    f.axes = Vector{Axes{typeof(f.g)}}()
    GP_ENV["CURAXES"] = nothing
    return
end


"""
    isempty(fig)

Return a bool indicating whether `fig` has axes or not.
"""
isempty(fig::Figure) = isempty(fig.axes)

"""
    destroy!(fig)

Remove reference to `fig` and set the current figure to nothing.
"""
destroy!(fig) = (delete!(GP_ENV["ALLFIGS"], fig.id); GP_ENV["CURFIG"] = nothing)
