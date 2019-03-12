function apply_drawing!(g::GLE, scatter::Scatter3D, el_cntr::Int, figid::String, axidx::Int)
    faux = auxpath(hash(scatter.data), figid, axidx)
    isfile(faux) || csv_writer(faux, scatter.data, false)

    # find the figure and axes (NOTE needed for axlims)
    fig = Figure(figid; _noreset=true)
    ax  = fig.axes[axidx]

    # retrieve limits, needed to get the scale right
    xmin  = ax.xaxis.min
    xspan = ax.xaxis.max - xmin
    ymin  = ax.yaxis.min
    yspan = ax.yaxis.max - ymin

    # check if there's a line or not
    if isdef(scatter.linestyle.lstyle)
        # need to add our own sub
        add_sub_plot3!(fig)
        "\ngsave"    |> g
        apply_linestyle!(g, scatter.linestyle; nosmooth=true, addset=true)
        "\nplot3 \"$faux\" $xmin $xspan $ymin $yspan" |> g
        "\ngrestore" |> g
    else
        # just scatter, GLE handles most of it
        # XXX points ...
    end
    return el_cntr + 1
end

#=
NOTE

* need to think about how to push and retrieve axes, they MUST be present otherwise
the whole thing is badly scaled.

any call --> update axes lims
assembling --> call axes lims

=#
