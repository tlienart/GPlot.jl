"""
    assemble_figure(f)

Internal function to generate and write the GLE script associated with the
figure object `f`.
"""
function assemble_figure(f::Figure{GLE}; debug=false)
    g = f.g
    "size $(f.size[1]) $(f.size[2])" |> g
    # background color if different than nothing or white
    if isdef(f.bgcolor) && f.bgcolor != colorant"white"
        # add a box that is slightly larger than the size
        "\namove -0.05 -0.05" |> g
        "\nbox $(f.size[1]+0.1) $(f.size[2]+0.1)" |> g
        "fill $(col2str(f.bgcolor)) nobox" |> g
    end
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
    write(g.io, "\n")
    # NOTE: this organisation is so that if axes need extra
    # subroutines, these will be generated after applying axes
    # but need to be put before in the GLE script
    gtemp = GLE()
    foreach(a -> apply_axes!(gtemp, a, f.id), f.axes)
    if !isempty(f.subroutines)
        for sub ∈ values(f.subroutines)
            sub |> g
        end
    end
    gtemp |> g
    # deal with proper dir
    if debug
        return String(take!(g))
    else
        write(joinpath(GP_ENV["TMP_PATH"], f.id * ".gle"), take!(g))
        return ""
    end
end

"""
    debug_gle(f)

Print the GLE script associated with figure `f` for debugging.
"""
debug_gle(f::Figure{GLE}) = println(assemble_figure(f; debug=true))

assemble_figure(f::Figure{Gnuplot}) = throw(NotImplementedError("assemble_figure:Gnuplot"))
