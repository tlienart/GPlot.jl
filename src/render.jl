"""
    cleanup(fig; exclude)

Internal function to delte all auxiliary files associated with the figure `fig` apart from those
contained in `exclude`. In particular: any data files supporting `Drawings` object and any `.gle`
script. This function is called after the `gle` engine is called (after an output image has
been generated) and only if the flag `GP_ENV["DEL_INTERM"]` is set to `true` (default).
"""
function cleanup(fig::Figure{GLE}; exclude=Vector{String}())
    # aux `.gle` folder
    rm(joinpath(GP_ENV["TMP_PATH"], ".gle"), recursive=true, force=true)
    # aux `fig.id...` files
    auxfiles = filter!(f -> startswith(f, fig.id), readdir(GP_ENV["TMP_PATH"]))
    for af ∈ auxfiles
        (af ∈ exclude) || rm(joinpath(GP_ENV["TMP_PATH"], af), force=true)
    end
    return
end

"""
    savefig()
    savefig(fname)
    savefig(fig; opts...)
    savefig(fig, fname; opts...)

Save the current figure (`gcf()`) or the figure `fig` to file. If the name `fname` is provided
with an extension, that name will be used and the extension will be used to determine the output
format. If no `fname` is provided, the `fig.id` will be used. Optional keyword arguments are:

* `format`: a string specifying the output format when the `fname` does not specify an extension,
possible formats are `eps|ps|pdf|svg|jpg|png`.
* `path`: a string specifying the output path where the output file should be saved. If it doesn't
exist, an attempt will be made to create it (which may fail). By default the file is saved in
the current folder.
* `res` or `resolution`: output file resolution (typical number is 200).
"""
function savefig(fig::Figure{GLE}, fn::String="";
                 format::String="png", path::String="", opts...)

    isempty(fig) && (@warn "The figure is empty, nothing to render."; return)
    isempty(fn)  && (fn = joinpath(path, fig.id * ".$format"))
    # buffer for the GLE command that will be called
    glecom = IOBuffer()
    # extract device from file name
    fn, ext = splitext(fn)
    isempty(ext) && (ext = ifelse(isempty(format), ".png", format))
    ext = lowercase(ext[2:end])
    ext ∈ ["eps", "ps", "pdf", "svg", "jpg", "png"] ||
            throw(OptionValueError("output file type", ext))
    # get default parameters, change if required
    res = 200
    for optname ∈ opts.itr
        if optname ∈ [:res, :resolution]
            r = posint(Int(opts[optname]))
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
        @warn("The directory $dir does not exist. I will try to create it and save there.")
        mkpath(dir) # this may error
    end
    fout = fpo * ".$ext"
    # GPlot assembling
    assemble_figure(fig)
    # GLE compilation
    glecom = pipeline(`gle -d $ext -r $res $cairo $texlabels -vb 0 -o $fout $fin`,
                       stdout=flog, stderr=flog)
    # in case of failure...
    if !success(glecom)
        log = read(flog, String)
        GP_ENV["DEL_INTERM"] && cleanup(fig)
        error("GLE error: ... \n$log")
    end
    # cleanup if required and return output file name
    GP_ENV["DEL_INTERM"] && cleanup(fig, [fn * ".$ext"])
    return fout
end
savefig(fn::String=""; opts...) = savefig(gcf(), fn; opts...)

"""
    PreviewFigure

Internal type to wrap around a figure that is to be previewed. A draft PNG file will be generated
for quick preview in IJulia or Atom.
"""
struct PreviewFigure
    fig::Figure
    fname::String
end

function PreviewFigure(fig::Figure)
    disp  = (isdefined(Main, :Atom)   && Main.Atom.PlotPaneEnabled.x) ||
            (isdefined(Main, :IJulia) && Main.IJulia.inited)
    disp || error("Preview is only available in Juno and IJulia.")
    # trigger a draft build
    fname = savefig(fig, res=100)
    isdef(fname) || return
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
