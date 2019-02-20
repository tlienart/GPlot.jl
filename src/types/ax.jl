@with_kw mutable struct Axis
    prefix::String # x, y, x2, y2, z
    # ---
    ticks    ::Ticks     = Ticks()  # ticks of the axis
    textstyle::TextStyle = TextStyle() # parent textstyle of axis
    # ---
    title ::Option{Title}   = ∅ # title of the axis
    base  ::Option{Float64} = ∅ # scale font and ticks
    lwidth::Option{Float64} = ∅ # width of the axis spine
    min   ::Option{Float64} = ∅ # minimum span of the axis
    max   ::Option{Float64} = ∅ # maximum span of the axis
    # -- toggle-able
    off   ::Option{Bool}    = ∅ # if true, axis is not shown
    log   ::Option{Bool}    = ∅ # log scale
end
Axis(p::String) = Axis(prefix=p)

abstract type Axes{B <: Backend} end

@with_kw mutable struct Axes2D{B} <: Axes{B}
    xaxis ::Axis = Axis("x")
    x2axis::Axis = Axis("x2")
    yaxis ::Axis = Axis("y")
    y2axis::Axis = Axis("y2")
    # ---
    drawings::Vector{Drawing2D} = Vector{Drawing2D}()
    objects ::Vector{Object2D}  = Vector{Object2D}()
    # ---
    title ::Option{Title}  = ∅
    size  ::Option{T2F}    = ∅ # (width cm, height cm)
    legend::Option{Legend} = ∅
    # -- toggle-able
    math  ::Option{Bool}   = ∅ # axis crossing (0, 0)
    # ---
    origin::Option{T2F}    = ∅ # related to layout
end

function Base.show(io::IO, ::MIME"text/plain", a::Axes2D{GLE})
    s = "GPlot.Axes2D{GLE}" *
        "\n\t"*rpad("Title:", 15) * (isdef(a.title) ? "\"$(a.title.text)\"" : "none") *
        "\n\t"*rpad("N. drawings:", 15) * "$(length(a.drawings))" *
        "\n\t"*rpad("N. objects:", 15) * "$(length(a.objects))" *
        "\n\t"*rpad("Math mode:", 15) * (isdef(a.math) ? a.math : "false") *
        "\n\t"*rpad("Layout origin:", 15) * (isdef(a.origin) ? "$(round.(a.origin, digits=1))" : "auto")
    write(io, s)
    return nothing
end


mutable struct Axes3D{B} <: Axes{B} end # XXX not yet defined
