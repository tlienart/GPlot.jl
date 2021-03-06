# COMPAT

if VERSION < v"1.1"
    isnothing(o) = (o === nothing)
    export isnothing
    eachcol(A::AbstractArray) = (view(A, :, j) for j ∈ axes(A, 2))
end

if VERSION <= v"1.1"
    import Base:startswith
    Base.startswith(s::AbstractString, r::Regex) = (rr = Regex("^"*r.pattern); occursin(rr, s))
end

#######################################


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
|>(s::String, b::Backend)   = write(b.io, s, " ")
|>(s::String, tio::Tuple)   = @. |>(s, tio)

# read buffer encapsulated by `b`
take!(b::Backend) = take!(b.io)

|>(bin::Backend, bout::Backend) = write(bout.io, take!(bin))

#######################################

isdef(el) = (el !== nothing)

# check if object `obj` has at least one field that is not "Nothing"
# this is useful when dealing with objects with lots of "Optional" fields
isanydef(obj) = any(isdef, (getfield(obj, f) for f ∈ fieldnames(typeof(obj))))

# see cla! (clear axes)
function reset!(obj::T; exclude=Vector{Symbol}(), inits...) where T
    # create a new object of the same type, assumes there is
    # a constructor that accepts empty input
    fresh = T(; inits...)
    for fn ∈ fieldnames(T)
        fn ∈ exclude && continue
        # set all fields to the field value given by the default
        # constructor (but keeps the address of the parent object)
        setfield!(obj, fn, deepcopy(getfield(fresh, fn)))
    end
    return obj
end

#######################################

rmin(x,::Nothing)  = x
rmin(::Nothing, y) = y
rmin(x,y) = min(x,y)

rmax(x,::Nothing)  = x
rmax(::Nothing, y) = y
rmax(x,y) = max(x,y)

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
function col2str(col::Colorant; str=false)
    crgba = convert(RGBA, col)
    r, g, b, α = round3d.([crgba.r, crgba.g, crgba.b, crgba.alpha])
    s  = "rgba($r,$g,$b,$α)"
    # used by str(markerstyle), remove things that confuse gle
    sr = replace(s, r"[\(\),\.]"=>"_")
    return ifelse(str, sr, s)
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

nvec(n::Int, T) = [T() for _ ∈ 1:n]

#######################################

function csv_writer(path::String, z, hasmissing::Bool)
    dirpath = splitdir(path)[1]
    isdir(dirpath) || mkpath(dirpath)
    if hasmissing
        tempio = IOBuffer()
        writedlm(tempio, z)
        # NOTE assumes it's fine to materialize the buffer with huge arrays
        # it's probably not ideal but in general should be fine, huge arrays are more
        # likely to happen with 3D objects (mesh) which are somewhat less likely to have missings
        temps = String(take!(tempio))
        write(path, replace(temps, r"missing|NaN|Inf"=>"?"))
    else
        writedlm(path, z)
    end
    return nothing
end

#######################################

"""
    tex_str(s)

Allows use of \$ and \\ while also allowing interpolation via `##name`. This is useful
for labels that contain tex-like expressions that may be generated in a sequence.

### Example

```julia
 i=5
t"\$x+##i\$" # amounts to "\$x+5\$"
```
"""
macro tex_str(s)
    m = match(r"##([_\p{L}](?:[\p{L}\d_]*))", s)
    m === nothing && return s
    v = Symbol(m.captures[1])
    esc(:(replace($s, r"##([_\p{L}](?:[\p{L}\d_]*))"=>string(eval($v)))))
end

@eval const $(Symbol("@t_str")) = $(Symbol("@tex_str"))

@eval const $(Symbol("@c_str")) = $(Symbol("@colorant_str"))

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
