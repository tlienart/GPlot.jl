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
