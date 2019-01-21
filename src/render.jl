function cleanup(fig::Figure{GLE}, exclude=Vector{String}())
    # aux `.gle` folder
    rm(joinpath(GP_ENV["TMP_PATH"], ".gle"), recursive=true, force=true)
    # aux `fig.id...` files
    auxfiles = filter!(f -> startswith(f, fig.id), readdir(GP_ENV["TMP_PATH"]))
    for af ∈ auxfiles
        (af ∈ exclude) || rm(joinpath(GP_ENV["TMP_PATH"], af), force=true)
    end
    return
end


function savefig(fig::Figure{GLE}
               , fn::String=""
               ; format::String="png"
               , path::String=""
               , opts...)

    isempty(fig) && (@warn "The figure is empty, nothing to save."; return)
    isempty(fn)  && (fn = joinpath(path, fig.id * ".$format"))

    # buffer for the GLE command that will be called
    glecom = IOBuffer()

    # extract device from file name
    fn, ext = splitext(fn)
    ext == "" && (ext = ".png")
    ext = ext[2:end]
    ext ∈ ["eps", "ps", "pdf", "svg", "jpg", "png"] ||
            throw(OptionValueError("output file type", ext))

    # get default parameters, change if required
    res = 200
    for optname ∈ opts.itr
        if optname ∈ [:res, :resolution]
            r = opts[optname]
            ((r isa Int) && (0 < r)) || throw(OptionValueError("resolution", r))
            res = r
        else
            throw(UnknownOptionError(optname, "gle command"))
        end
    end

    # get transparency & tex
    cairo = ifelse(isdef(fig.transparency), `-cairo`, ``)
    texlabels = ifelse(isdef(fig.texlabels), `-tex`, ``)

    # fin - fout
    fto  = joinpath(GP_ENV["TMP_PATH"], fig.id)
    fin  = fto * ".gle"
    flog = fto * ".log"
    fpo  = normpath(joinpath(pwd(), fn))
    dir = splitdir(fpo)[1]
    if !isdir(dir)
        @warn("The directory $dir does not exist. " *
              "I will try to create it and save there.")
        mkpath(dir)
    end
    fout = fpo * ".$ext"

    # GPlot assembling
    assemble_figure(fig)

    # GLE compilation
    glecom = pipeline(`gle -d $ext -r $res $cairo $texlabels -vb 0 -o $fout $fin`, stdout=flog, stderr=flog)

    if !success(glecom)#`bash -c $glecom`)
        log = read(flog, String)
        GP_ENV["DEL_INTERM"] && cleanup(fig)
        error("GLE error: ... \n$log")
    end

    # cleanup if required and return output file name
    GP_ENV["DEL_INTERM"] && cleanup(fig, [fn * ".$ext"])
    return fout
end

savefig(fn::String=""; opts...) = savefig(gcf(), fn; opts...)


struct PreviewFigure
    fig::Figure
    fname::String
end

function PreviewFigure(fig::Figure)
    disp  = (isdefined(Main, :Atom)   && Main.Atom.PlotPaneEnabled.x) ||
            (isdefined(Main, :IJulia) && Main.IJulia.inited)
    disp || error("Preview is only available in Juno and IJulia.")
    # trigger a build
    fname = savefig(fig, res=200)
    return PreviewFigure(fig, fname)
end

preview(fig::Figure) = PreviewFigure(fig)
preview() = preview(gcf())
render(fig::Figure) = PreviewFigure(fig)
render() = render(gcf())


function Base.show(io::IO, ::MIME"image/png", pfig::PreviewFigure)
    write(io, read(pfig.fname))
    GP_ENV["DEL_INTERM"] && rm(pfig.fname)
end
