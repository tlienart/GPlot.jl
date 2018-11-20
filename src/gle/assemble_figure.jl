function assemble_figure(f::Figure{GLE})
    g = f.g
    "size $(f.size[1]) $(f.size[2])" |> g
    "\nset" |> g
    apply_textstyle!(g, f.textstyle)
    ifdef(f.texlabels) && ifelse(f.texlabels, "\nset texlabels 1", "") |> g
    ifdef(f.texscale) && "\nset texscale $(f.texscale)" |> g

    # XXX XXX XXX XXX XXX XXX
    # XXX deal with layout, sandbox below
    "\nbegin graph" |> g
    apply_axes!(g, f.axes[1])
    "\nend graph" |> g
    # deal with proper dir
    write("$GP_TMP_PATH/$(f.id).gle", take!(g))
end


function assemble_figure(f::Figure{Gnuplot})
    throw(NotImplementedError("assemble_figure:Gnuplot"))
end
