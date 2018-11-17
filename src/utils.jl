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


const Float = Float64
const VF    = Vector{Float}
const MF    = Matrix{Float}
const Option{T} = Union{Nothing, T}
const ∅ = nothing

isdef(el) = !(el === nothing)

round3d(x) = round(Float(x), digits=3)


function col2str(col::T) where T<:Colorant
    crgba = convert(RGBA, col)
    r, g, b, a = crgba.r, crgba.g, crgba.b, crgba.alpha
    r, g, b, a = round3d.([r, g, b, a])
    return "rgba($r, $g, $b, $a)"
end


vec2str(v::Vector{T}) where T<:Real = prod("$vi " for vi ∈ v)
vec2str(v::Vector{String}) = prod("\"$vi\" " for vi ∈ v)


struct NotImplementedError <: Exception
    msg::String
end
NotImplementedError(s) = NotImplementedError("[$s] hasn't been implemented.")


gle_no_support(s) = GP_VERBOSE &&
    println("🚫  GLE does not support $s [ignoring]")
