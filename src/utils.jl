abstract type Backend end

struct GLE <: Backend
    io::IOBuffer
end
GLE() = GLE(IOBuffer())

struct Gnuplot <: Backend
    io::IOBuffer
end
Gnuplot() = Gnuplot(IOBuffer())

|>(s, io::IOBuffer) = write(io, s, " ")
|>(s, b::Backend)   = write(b.io, s, " ")
|>(s, tio::Tuple)   = @. |>(s, tio)
take!(b::Backend)   = take!(b.io)

#######################################

isdef(el)   = !(el === nothing)
isanydef(o) = any(isdef, (getfield(o, f) for f ∈ fieldnames(typeof(o))))

function clear!(obj::T) where T
    for fn ∈ fieldnames(T)
        (Nothing <: fieldtype(T, fn)) && setfield!(obj, fn, nothing)
    end
    return
end

#######################################

round3d(x) = round(Float(x), digits=3)

function col2str(col::T) where T<:Colorant
    crgba = convert(RGBA, col)
    r, g, b, a = crgba.r, crgba.g, crgba.b, crgba.alpha
    r, g, b, a = round3d.([r, g, b, a])
    return "rgba($r,$g,$b,$a)"
end

vec2str(v::Vector{T}) where T<:Real = prod("$vi " for vi ∈ v)
vec2str(v::Vector{String}) = prod("\"$vi\" " for vi ∈ v)

#######################################

struct NotImplementedError <: Exception
    msg::String
    NotImplementedError(s) = new("[$s] hasn't been implemented.")
end

struct UnknownOptionError <: Exception
    msg::String
    UnknownOptionError(s, o) = new("[$s] is not recognised as a valid option name for $(typeof(o)).")
end

struct OptionValueError <: Exception
    msg::String
    OptionValueError(s, v) = new("[$s] value given ($v) did not meet the expected format.")
end

gle_no_support(s) = GP_VERBOSE && println("🚫  GLE does not support $s [ignoring]")

#######################################

macro tex_str(s)
    m = match(r"##([_\p{L}](?:[\p{L}\d_]*))", s)
    m === nothing && return s
    v = Symbol(m.captures[1])
    esc(:(replace($s, r"##([_\p{L}](?:[\p{L}\d_]*))"=>string(eval($v)))))
end

@eval const $(Symbol("@t_str")) = $(Symbol("@tex_str"))
