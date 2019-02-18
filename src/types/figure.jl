mutable struct Figure{B<:Backend}
    id          ::String             # unique id of the figure
    g           ::B                  # description stream
    axes        ::Vector{Axes{B}}    # subplots
    size        ::NTuple{2,Float64}  # (width, heigth)
    textstyle   ::TextStyle          # parent font etc
    # ---
    texlabels   ::Option{Bool}       # true if has tex
    texscale    ::Option{String}     # scale latex * hei (def=1)
    texpreamble ::Option{String}     # latex preamble
    transparency::Option{Bool}       # if true, use cairo device
    # ---
    subroutines::Dict{String,String}
end

function Base.show(io::IO, ::MIME"text/plain", f::Figure{GLE})
    s = "GPlot.Figure{GLE}" *
        "\n\t"*rpad("Name:", 15) * (f.id == "_fig_" ? "default (\"_fig_\")" : "\"$(f.id)\"") *
        "\n\t"*rpad("Size:", 15) * "$(round.(f.size, digits=1))" *
        "\n\t"*rpad("N. axes:", 15) * "$(length(f.axes))" *
        "\n\t"*rpad("LaTeX:", 15) * (isdef(f.texlabels) ? "$(f.texlabels)" : "false") *
        "\n\t"*rpad("Transparent:", 15) * (isdef(f.transparency) ? "$(f.transparency)" : "false")
    write(io, s)
    return nothing
end
