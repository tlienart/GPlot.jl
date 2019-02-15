"""
    assemble_figure(f)

Internal function to generate and write the GLE script associated with the
figure object `f`.
"""
function assemble_figure(f::Figure{GLE}; debug=false)
    g = f.g
    "size $(f.size[1]) $(f.size[2])" |> g
    # check if has latex
    haslatex = false
    any(isdef, (f.texscale, f.texpreamble)) && (haslatex = true)
    isdef(f.texlabels) && (haslatex = f.texlabels)
    # line for texstyle, it may be empty if nothing is given
    "\nset" |> g
    isdef(f.textstyle) && apply_textstyle!(g, f.textstyle)
    # latex if required
    if haslatex
        if isdef(f.texpreamble)
            "\nbegin texpreamble\n" |> g
            f.texpreamble           |> g
            "\nend texpreamble"     |> g
        end
        "\nset texlabels 1" |> g
        "\nset texscale"    |> g
        ifelse(isdef(f.texscale), f.texscale, "scale") |> g
    end
    foreach(a -> apply_axes!(g, a, f.id), f.axes)
    # deal with proper dir
    if debug
        return String(take!(g))
    else
        write(joinpath(GP_ENV["TMP_PATH"], f.id * ".gle"), take!(g))
        return
    end
end

"""
    debug_gle(f)

Print the GLE script associated with figure `f` for debugging.
"""
debug_gle(f::Figure{GLE}) = println(assemble_figure(f; debug=true))

function assemble_figure(f::Figure{Gnuplot})
    throw(NotImplementedError("assemble_figure:Gnuplot"))
end