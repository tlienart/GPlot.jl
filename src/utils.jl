isjupyter = isdefined(Main, :IJulia) && Main.IJulia.inited

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


const Float = Float64
const VF    = Vector{Float}
const AVF   = AbstractVector{Float}
const MF    = Matrix{Float}
const Option{T} = Union{Nothing, T}
const ∅ = nothing
const PT_TO_CM = 0.0352778 # 1pt in cm

isdef(el) = !(el === nothing)

round3d(x) = round(Float(x), digits=3)


function col2str(col::T) where T<:Colorant
    crgba = convert(RGBA, col)
    r, g, b, a = crgba.r, crgba.g, crgba.b, crgba.alpha
    r, g, b, a = round3d.([r, g, b, a])
    return "rgba($r,$g,$b,$a)"
end


vec2str(v::Vector{T}) where T<:Real = prod("$vi " for vi ∈ v)
vec2str(v::Vector{String}) = prod("\"$vi\" " for vi ∈ v)


struct NotImplementedError <: Exception
    msg::String
end
NotImplementedError(s) = NotImplementedError("[$s] hasn't been implemented.")

struct UnknownOptionError <: Exception
    msg::String
end
UnknownOptionError(s, o) = UnknownOptionError("[$s] is not recognised as a valid option name for $(typeof(o)).")

struct OptionValueError <: Exception
    msg::String
end
OptionValueError(s, v) = OptionValueError("[$s] value given ($v) did not meet the expected format.")


gle_no_support(s) = GP_VERBOSE &&
    println("🚫  GLE does not support $s [ignoring]")
