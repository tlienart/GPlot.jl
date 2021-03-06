"""
    cleanup(fig, exclude)

Internal function to delte all auxiliary files associated with the figure `fig` apart from those
contained in `exclude`. In particular: any data files supporting `Drawings` object and any `.gle`
script. This function is called after the `gle` engine is called (after an output image has
been generated) and only if the flag `GP_ENV["DEL_INTERM"]` is set to `true` (default).
"""
function cleanup(fig::Figure{GLE}, exclude=Vector{String}())
    # aux `.gle` folder
    rm(joinpath(GP_ENV["TMP_PATH"], fig.id * ".gle"), force=true)
    # aux `fig.id...` files
    auxfiles = Iterators.filter(f -> startswith(f, fig.id), readdir(GP_ENV["TMP_PATH"]))
    for af ∈ auxfiles
        (af ∈ exclude) || rm(joinpath(GP_ENV["TMP_PATH"], af), force=true)
    end
    return nothing
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
* `res`: output file resolution (typical number is 200).
"""
function savefig(fig::Figure{GLE}, fn::String="";
                 format::String="png", path::String="", res::Int=200, _noout=false)

    GP_ENV["HAS_BACKEND"] || (@warn "No backend available to render the figure."; return)

    # by default take the figure id as name
    isempty(fn) && (fn = fig.id)
    # extract device from file name (if any)
    fn, ext = splitext(fn)
    isempty(ext) && (ext = ifelse(isempty(format), "png", format))
    ext = lowercase(ext)
    startswith(ext, ".") && (ext = ext[2:end])

    # check it's associated with a valid output type
    ext ∈ ["eps", "ps", "pdf", "svg", "jpg", "png"] ||
            throw(OptionValueError("output file type", ext))

    # read parameters from the `fig`: transparency & tex
    cairo     = ifelse(isdef(fig.transparency), `-cairo`, ``)
    texlabels = ifelse(isdef(fig.texlabels),    `-tex`,   ``)
    # path for the GLE script and the log
    fto  = joinpath(GP_ENV["TMP_PATH"], fig.id)
    fin  = fto * ".gle"
    flog = fto * ".log"
    # path for the output file
    fpo  = normpath(ifelse(isempty(path), joinpath(pwd(), fn), joinpath(path, fn)))
    # check the output dir
    dir = splitdir(fpo)[1]
    if !isdir(dir)
        @warn("The directory $dir does not exist. I will try to create it and save there.")
        mkpath(dir) # this may error
    end
    fout = fpo * ".$ext"
    # check what to do given the background
    transparent = ifelse(isnothing(fig.bgcolor) || Colors.alpha(fig.bgcolor) < 1,
                         `-transparent`, ``)
    # Assemble the figure and compile the lot note that assemble_figure writes to `fin`
    # (see also apply_gle/figure)
    assemble_figure(fig)
    glecom = pipeline(`gle -d $ext -r $res $cairo $texlabels $transparent -vb 0 -o $fout $fin`, stdout=flog, stderr=flog)
    # only for warmup: finish early (don't call gle)
    _noout && return
    # spwan the gle command, and check if it failed
    if _noout || !success(glecom)
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

Internal type to wrap around a figure that is to be previewed. It may be previewed as an image.
"""
struct PreviewFigure
    fig::Figure
end

"""
    ImgPreview

Internal type to wrap around a figure that is to be previewed as an image. Note the distinction
with `PreviewFigure` which precedes it and ends up being shown as an image only if the continuous
preview toggle is on (`GP_ENV["CONT_PREVIEW"]`).
"""
struct ImgPreview
    fig::Figure
end

# NOTE tricks to suppress automatic opening of plot panel in atom
preview(f::Figure) = ImgPreview(f)
preview() = preview(gcf())

function Base.show(io::IO, obj::Union{PreviewFigure,DrawingHandle})
    GP_ENV["CONT_PREVIEW"] || return nothing
    fig = isa(obj, PreviewFigure) ? obj.fig : gcf()
    display(ImgPreview(fig))
    return nothing
end

function Base.show(io::IO, ::MIME"image/png", obj::ImgPreview)
    # check if can display
    (isdefined(Main, :Atom) && Main.Atom.PlotPaneEnabled.x) ||
        (isdefined(Main, :IJulia) && Main.IJulia.inited)    ||
            (@warn("Preview is only available in Juno and IJulia."); return nothing)
    # trigger a draft build
    isdir(GP_ENV["TMP_PATH"]) || mkpath(GP_ENV["TMP_PATH"])
    fname = savefig(obj.fig, "__PREVIEW__"; res=100, path=GP_ENV["TMP_PATH"])
    isnothing(fname) && return nothing
    # write to IO
    write(io, read(fname))
    GP_ENV["DEL_INTERM"] && rm(fname)
    return nothing
end
