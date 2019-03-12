GP_ENV["ALLFIGS"] = Dict{String, Figure}()
GP_ENV["CURFIG"]  = nothing
GP_ENV["CURAXES"] = nothing

"""
    gcf()

Return the current active Figure or a new figure if there isn't one.
See also [`gca`](@ref).
"""
gcf() = isdef(GP_ENV["CURFIG"]) ? GP_ENV["CURFIG"] : Figure() # no ifelse here

"""
    gca()

Return the current active Axes and `nothing` if there isn't one.
See also [`gcf`](@ref).
"""
gca() = GP_ENV["CURAXES"] # if nothing, whatever called it will create

"""
    check_axes(a)

Internal function to check if `a` is defined, if not it calls `gca` if `gca` also
returns `nothing`, it adds axes. Used in `plot!` etc.
"""
function check_axes(a::Option{Axes2D})
    isdef(a) || (a = gca())
    isdef(a) || (a = add_axes2d!())
    return a
end

"""
    check_axes_3d(a)

See [`check_axes`](@ref), the only difference here is that it's for 3D axes.
"""
function check_axes_3d(a::Option{Axes3D})
    isdef(a) || (a = gca())
    isdef(a) && isa(a, Axes3D) && return a
    add_axes3d!()
end

"""
    get_backend(f)

Return the backend type associated with figure `f`.
"""
get_backend(f::Figure{B}=gcf()) where {B} = B

"""
    palette(v::Vector{Color})

Set the default palette. To see the current one, write `GPlot.GP_ENV["PALETTE"]` in the REPL.
"""
set_palette(v::Vector{<:Color}) = (GP_ENV["PALETTE"] = v; GP_ENV["SIZE_PALETTE"] = length(v); ∅)

"""
    continuous_preview(b)

Set the continuous preview on (`b=true`, default value) or off.
"""
continuous_preview(b::Bool) = (GP_ENV["CONT_PREVIEW"] = b)
