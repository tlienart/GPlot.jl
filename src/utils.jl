abstract type Backend end

struct GLE <: Backend
    io::IOBuffer
end
GLE() = GLE(IOBuffer())

struct Gnuplot <: Backend
    io::IOBuffer
end
Gnuplot() = Gnuplot(IOBuffer())

|>(s, b::Backend) = write(b.io, s, " ")
take!(b::Backend) = take!(b.io)

#######################################

isdef(el)   = !(el === nothing)
isanydef(o) = any(isdef, (getfield(o, f) for f ∈ fieldnames(typeof(o))))

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
