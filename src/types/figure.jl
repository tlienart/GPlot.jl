mutable struct Figure{B<:Backend}
    # NOTE: couldn't use @kw_args here, clashed with the format of the base constructor.
    g ::B      # description buffer
    id::String # id of the figure
    # ---
    axes     ::Vector{Axes{B}}   # subplots
    size     ::NTuple{2,Float64} # (width, heigth)
    textstyle::TextStyle         # parent font etc
    bgcolor  ::Option{Colorant}  # background col, nothing=transparent
    # ---
    texlabels   ::Option{Bool}   # true if has tex
    texscale    ::Option{String} # scale latex * hei (def=1)
    texpreamble ::Option{String} # latex preamble
    transparency::Option{Bool}   # if true, use cairo device
    # ---
    subroutines::Dict{String,String}
end
Figure(g::B, id::String) where B<:Backend =
    Figure(g, id, Vector{Axes{B}}(), (12., 9.), TextStyle(font="texcmss", hei=0.35),
           colorant"white", ∅, ∅, ∅, ∅, Dict{String,String}())

"""
    reset!(f)

Internal function to completely refresh the figure `f` only keeping its id and size.
"""
function reset!(f::Figure{B}) where B
    take!(f.g) # empty the buffer
    f.axes         = Vector{Axes{B}}() # clean axes
    f.textstyle    = TextStyle(font="texcmss", hei=0.35) # default fontstyle
    f.bgcolor      = colorant"white" # default bg color
    f.texlabels    = ∅
    f.texscale     = ∅
    f.texpreamble  = ∅
    f.transparency = ∅
    f.subroutines  = Dict{String,String}()
    GP_ENV["CURFIG"]  = f
    GP_ENV["CURAXES"] = nothing
    return f
end

function Base.show(io::IO, ::MIME"text/plain", f::Figure{GLE})
    tbg = (f.bgcolor === nothing)
    wbg = (f.bgcolor == RGB(1,1,1))
    s = "GPlot.Figure{GLE}" *
        "\n\t"*rpad("Name:", 15) * (f.id == "_fig_" ? "default (\"_fig_\")" : "\"$(f.id)\"") *
        "\n\t"*rpad("Size:", 15) * "$(round.(f.size, digits=1))" *
        "\n\t"*rpad("Bg. color:", 15) * (tbg ? "none" : ifelse(wbg, "white", col2str(f.bgcolor))) *
        "\n\t"*rpad("N. axes:", 15) * "$(length(f.axes))" *
        "\n\t"*rpad("LaTeX:", 15) * (isdef(f.texlabels) ? "$(f.texlabels)" : "false") *
        "\n\t"*rpad("Transparent:", 15) * (isdef(f.transparency) ? "$(f.transparency)" : "false")
    write(io, s)
    return nothing
end
