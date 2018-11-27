function savefig(fig::Figure{GLE}, fn::String=""; opts...)
    isempty(fig) && (@warn "The figure is empty, nothing to save."; return)
    isempty(fn) && (fn = fig.id * ".png")
    glecom = IOBuffer()
    GLE_APP_PATH |> glecom
    # extract device from file name
    fn, ext = splitext(fn)
    ext == "" && (ext = ".png")
    ext = ext[2:end]
    ext ∈ ["eps", "ps", "pdf", "svg", "jpg", "png"] || throw(OptionValueError("output type", ext))
    # set device
    "-d $ext" |> glecom
    # set default parameters, change if required
    resolution = 250

    for optname ∈ opts.itr
        if optname ∈ [:res, :resolution]
            res = opts[optname]
            ((res isa Int) && (0 < res)) || throw(OptionValueError("resolution", res))
            resolution = res
        else
            throw(UnknownOptionError(optname, "gle command"))
        end
    end
    # set resolution
    "-r $resolution" |> glecom
    # set transparency & tex
    isdef(fig.transparency) && fig.transparency && "-cairo" |> glecom
    isdef(fig.texlabels)    && fig.texlabels    && "-tex"   |> glecom
    # remove verbosity
    "-vb 0" |> glecom
    # fin - fout
    fin  = joinpath(GP_TMP_PATH, fig.id) * ".gle"
    fpo  = joinpath(GP_TMP_PATH, fn)
    fout = fpo * ".$ext"
    "$fin $fout > $fpo.glog 2>&1" |> glecom

    # GP assembling
    assemble_figure(fig)

    # GLE compilation
    glecom = String(take!(glecom))
    success(`bash -c "$glecom"`) || error("GLE error, check $fpo.glog.")
    return fout
end

savefig(fn=""; opts...) = savefig(gcf(), fn; opts...)


struct PreviewFigure
    fig::Figure
    fname::String
end

function PreviewFigure(fig::Figure)
    disp  = (isdefined(Main, :Atom) && Main.Atom.PlotPaneEnabled.x) ||
            (isdefined(Main, :IJulia) && Main.IJulia.inited)
    disp || error("Preview is only available in Juno and IJulia.")
    # trigger a build
    fname = savefig(fig)
    return PreviewFigure(fig, fname)
end

preview(fig::Figure) = PreviewFigure(fig)
render(fig::Figure)  = PreviewFigure(fig)

function Base.show(io::IO, ::MIME"image/png", pfig::PreviewFigure)
    write(io, read(pfig.fname))
    if GP_DEL_INTERM
        sfn = splitext(pfig.fname)[1]
        rm(sfn * ".gle")
        rm(pfig.fname)
    end
end
