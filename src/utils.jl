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
|>(s::String, io::IOBuffer) = write(io, s, " ")
|>(s::String, b::Backend)   = write(b.io, s, " ")
|>(s::String, tio::Tuple)   = @. |>(s, tio)

# read buffer encapsulated by `b`
take!(b::Backend) = take!(b.io)

|>(bin::Backend, bout::Backend) = write(bout.io, take!(bin))

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
    return obj
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

"""
    pzip(y)
    pzip(x, y)

Internal function to zip data checking the dimensions match and returning whether there are missing
values, how many data points there are, and how many objects (columns) there are. The possibilities
are:
* `y` - vector only, it will be paired with 1:length(y)
* `y` - matrix only, it will be paired with 1:size(y, 1)
* `x, y` - vector | matrix, it will check the number of rows match then [x y1 y2 ...]
"""
function pzip(x::AV{<:CanMiss{<:Real}}, y::AVM{<:CanMiss{<:Real}})
    length(x) == size(y, 1)  || throw(DimensionMismatch("x and y must have matching dimensions."))
    return (zip(x, eachcol(y)...),                 # the zip iterator
            Missing <: Union{eltype(x),eltype(y)}, # whether there are missing values
            size(y, 2))                            # number of objects (e.g. line/scatters)
end
pzip(y::AVM{<:CanMiss{<:Real}}) = pzip(1:size(y, 1), y)

function fzip(x::AVR, y::Union{Real,AVR}, z::Union{Real,AVR})
    y isa AV || (y = fill(y, length(x)))
    z isa AV || (z = fill(z, length(x)))
    length(x) == length(y) == length(z) || throw(DimensionMismatch("vectors must have = lengths"))
    return zip(x, y, z)
end

function hzip(x::AV{<:CanMiss{<:Real}})
    return (zip(x),                       #
            Missing <: eltype(x),         # whether there are missing values
            sum(e->1, skipmissing(x)),    # how many non-missing
            fl((minimum(x), maximum(x)))) # the range of the values
end

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

function csv_writer(path::String, z, hasmissing::Bool)
    if hasmissing
        tempio = IOBuffer()
        writedlm(tempio, z)
        # NOTE assumes it's fine to materialize the buffer with huge arrays
        # it's probably not ideal but in general should be fine, huge arrays are more
        # likely to happen with 3D objects (mesh) which are somewhat less likely to have missings
        temps = String(take!(tempio))
        write(path, replace(temps, "missing"=>"?"))
    else
        writedlm(path, z)
    end
    return nothing
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
