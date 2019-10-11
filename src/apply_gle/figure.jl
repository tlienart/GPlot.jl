"""
    assemble_figure(f)

Internal function to generate and write the GLE script associated with the
figure object `f`.
"""
function assemble_figure(f::Figure{GLE}; debug=false)::String
    g = f.g
    "size $(f.size[1]) $(f.size[2])" |> g

    # >> apply background color if different than nothing or white
    if isdef(f.bgcolor) && f.bgcolor != colorant"white"
        # add a box that is slightly larger than the size
        "\namove -0.05 -0.05" |> g
        "\nbox $(f.size[1]+0.1) $(f.size[2]+0.1)" |> g
        "fill $(col2str(f.bgcolor)) nobox" |> g
    end

    # >> apply latex
    # check if has latex
    haslatex = any(isdef, (f.texscale, f.texpreamble))
    isdef(f.texlabels) && (haslatex = f.texlabels)
    # line for texstyle, it may be empty if nothing is given
    apply_textstyle!(g, f.textstyle, addset=true)
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

    # >> apply axes
    # NOTE: this organisation is so that if axes need extra
    # subroutines, these will be generated after applying axes
    # but need to be put before in the GLE script
    gtemp = GLE();
    for (i, aᵢ) ∈ enumerate(f.axes)
        apply_axes!(gtemp, aᵢ, f.id, i)
    end
    if !isempty(f.subroutines)
        ks = keys(f.subroutines)
        # subroutines for palettes
        for key ∈ Iterators.filter(k->startswith(k, "cmap_"), ks)
            f.subroutines[key] |> g
        end
        # subroutines for drawings
        # -- boxplot, heatmap
        for key ∈ Iterators.filter(k -> startswith(k, "bp_") || startswith(k, "hm_"), ks)
            f.subroutines[key] |> g
        end
        # subroutines for markercolors
        for key ∈ Iterators.filter(k->startswith(k, "mk_"), ks) # special markers
            f.subroutines[key] |> g
        end
        # --------------
        # 3D subroutines
        # --------------
        "plot3" ∈ ks && f.subroutines["plot3"] |> g
    end
    gtemp |> g

    # >> either return as string or write to file
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
debug_gle(f::Figure{GLE}=gcf()) = println(assemble_figure(f; debug=true))
