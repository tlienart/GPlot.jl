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

    add_sub_plot3!(fig)
    "\ngsave"    |> g
    apply_linestyle!(g, scatter.linestyle; nosmooth=true, addset=true)

#=
 XXX here

 need to

 - modify the glesub to have the markers as well
 - if the mcol is specified, then like for scatter2d need
 to define a special marker and call that (identical situation)

 =#

    showline = Int(scatter.linestyle.lstyle != -1)

    "\nplot3 \"$faux\" $xmin $xspan $ymin $yspan $showline" |> g
    ms = scatter.markerstyle
    if isanydef(ms)
        "1"  |> g # showmarker
        isdef(ms.marker) || (ms.marker = "fcircle")
        mcol = isdef(ms.color)
        mcol && add_sub_marker!(fig, ms)
        isdef(ms.msize) || (ms.msize = 0.1)
        "$(ms.marker) $(ms.msize/fig.textstyle.hei)" |> g
    else
        "-1 fcircle 1" |> g # nothing shown
    end

    "\ngrestore" |> g
    return el_cntr + 1
end

#=
NOTE

* need to think about how to push and retrieve axes, they MUST be present otherwise
the whole thing is badly scaled.

any call --> update axes lims
assembling --> call axes lims

=#
