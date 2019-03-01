set_colormap!(h::Heatmap, c::Vector{<:Color}) = (h.colormap = c)

for ax ∈ ["x", "x2", "y", "y2"]
    a = Symbol("$(ax)names")
    s = 1 + (ax ∈ ["x", "x2"]) # which dimension to check: x->ncols, y->nrows
    f! = Symbol("set_$(a)!")
    ex = quote
        # set_xnames!, ...
        function $f!(h::Heatmap, names::Vector{String})
            size(h.data, $s) == length(names) || throw(DimensionMismatch("The names must match " *
                                                "the dimensions of the data matrix."))
            h.$a = names
            return nothing
        end
    end
    eval(ex)
end
