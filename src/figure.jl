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

# Other options (internal use mostly):

* `reset`: a bool, if true will erase the figure if it exists (instead of just returning it).
* `_noreset`: internal to indicate that if the figure has no name and is called whether a new one
should be sent or not (for the user: yes, internally: sometimes not as we want to retrieve
properties)
"""
function Figure(id::String="_fig_"; backend=GP_ENV["BACKEND"](), reset=false, _noreset=false, opts...)
    # return a fresh figure when calling Figure() unless _noreset
    if id == "_fig_" && !_noreset
        f = Figure(backend, id)
        set_properties!(f; defer_preview=true, opts...)
        GP_ENV["ALLFIGS"][id] = f
        GP_ENV["CURFIG"]  = f
        GP_ENV["CURAXES"] = nothing
        return f
    end
    # otherwise try to find an existing figure, if nothing found, return a new one as well
    f = get(GP_ENV["ALLFIGS"], id) do
        GP_ENV["ALLFIGS"][id] = Figure(backend, id)
    end
    reset && erase(f)
    GP_ENV["CURFIG"]  = f
    GP_ENV["CURAXES"] = isempty(f.axes) ? nothing : f.axes[1]
    set_properties!(f; defer_preview=true, opts...) # f exists but properties have been given
    return f
end

"""
    add_axes!(fig, ax)

Internal function to add axes `ax` to figure `fig`.
"""
function add_axes!(f::Figure, ax::Axes)
    push!(f.axes, ax)
    GP_ENV["CURAXES"] = ax
    return ax
end

"""
    add_axes2d!()

Internal function to add empty `Axes2D` to the current figure.
"""
add_axes2d!() = (f=gcf(); B=get_backend(f); add_axes!(f, Axes2D{B}()))

"""
    erase(fig)

Replaces `fig`'s current axes by a fresh, empty axes container. Note that
other properties of the figure are preserved (such as its size, latex
properties etc). See also [`clf`](@ref) and [`reset!`](@ref).
"""
function erase(f::Figure)
    # empty associated buffer
    take!(f.g)
    # give `f` a fresh set of axes
    f.axes = Vector{Axes{typeof(f.g)}}()
    GP_ENV["CURFIG"]  = f
    GP_ENV["CURAXES"] = nothing
    return f
end

"""
    clf()

Reset the current figure keeping only its current name and size, everything else is
set to the default parameters.
See also [`erase`](@ref) and [`reset!`](@ref)
"""
clf() = (reset!(gcf()); preview())

"""
    destroy(fig)

Internal function to remove all references to `fig` and set the current figure to nothing.
"""
function destroy(f::Figure)
    delete!(GP_ENV["ALLFIGS"], f.id)
    GP_ENV["CURFIG"]  = nothing
    GP_ENV["CURAXES"] = nothing
    return nothing
end
