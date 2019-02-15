abstract type Backend end

struct GLE <: Backend
    io::IOBuffer
end
GLE() = GLE(IOBuffer())

struct Gnuplot <: Backend
    io::IOBuffer
end
Gnuplot() = Gnuplot(IOBuffer())

# write to buffer (or buffer encapsulating object) with form (s |> b)
|>(s, io::IOBuffer) = write(io, s, " ")
|>(s, b::Backend) = write(b.io, s, " ")
|>(s, tio::Tuple) = @. |>(s, tio)

# read buffer encapsulated by `b`
take!(b::Backend)   = take!(b.io)

#######################################

if !isdefined(Base, :isnothing)
    isnothing(o) = (o === nothing)
    export isnothing
end

isdef(el) = (el !== nothing)

# check if object `obj` has at least one field that is not "Nothing"
# this is useful when dealing with objects with lots of "Optional" fields
isanydef(obj) = any(isdef, (getfield(obj, f) for f ∈ fieldnames(typeof(obj))))

# take an object and for any field that is optional, set the field to nothing
function clear!(obj::T; exclude=Vector{Symbol}()) where T
    for fn ∈ fieldnames(T)
        fn ∈ exclude && continue
        (Nothing <: fieldtype(T, fn)) && setfield!(obj, fn, nothing)
    end
    return
end

# see cla! (clear axes)
function reset!(obj::T; exclude=Vector{Symbol}()) where T
    # create a new object of the same type, assumes there is
    # a constructor that accepts empty input
    fresh = T()
    for fn ∈ fieldnames(T)
        fn ∈ exclude && continue
        # set all fields to the field value given by the default
        # constructor (but keeps the address of the parent object)
        setfield!(obj, fn, deepcopy(getfield(fresh, fn)))
    end
    return obj
end

#######################################

fl(::Missing) = missing
fl(::Nothing) = nothing
fl(x::Real)   = Float64(x)
fl(t::Tuple)  = fl.(t)
fl(v::AbstractVecOrMat) = fl.(v)

#######################################

# return a number with 3 digits accuracy, useful in col2str
round3d(x::Real) = round(x, digits=3)

# takes a colorant and transform it to a standard string rgba(...)
function col2str(col::Colorant)
    crgba = convert(RGBA, col)
    r, g, b, α = round3d.([crgba.r, crgba.g, crgba.b, crgba.alpha])
    return "rgba($r,$g,$b,$α)"
end

# unroll a vector into a string with the elements separated by a space
vec2str(v::Vector{T}) where T<:Real = prod("$vi " for vi ∈ v)
vec2str(v::Vector{String}) = prod("\"$vi\" " for vi ∈ v)
# separated vec to str for things like d1,d2,d3 etc
function svec2str(v::Vector{String}, sep=",")
    length(v) > 1 || return v[1]
    return prod(vi*sep for vi∈v[1:end-1])*v[end]
end
svec2str(v::Base.Generator, sep=",") = svec2str(collect(v), sep)

#######################################

csv_writer(path::String, data::VecOrMat{Float64}) = writedlm(path, data)
function csv_writer(path::String, data::VecOrMat{Union{Missing, Float64}})
    tempio = IOBuffer()
    writedlm(tempio, data)
    # NOTE assumes it's fine. With huge arrays is probably not ideal
    temps = String(take!(tempio))
    write(path, replace(temps, "missing"=>"?"))
end

#######################################

macro tex_str(s)
    m = match(r"##([_\p{L}](?:[\p{L}\d_]*))", s)
    m === nothing && return s
    v = Symbol(m.captures[1])
    esc(:(replace($s, r"##([_\p{L}](?:[\p{L}\d_]*))"=>string(eval($v)))))
end

@eval const $(Symbol("@t_str")) = $(Symbol("@tex_str"))

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
