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
    get_backend(f)

Return the backend type associated with figure `f`.
"""
get_backend(f::Figure{B}=gcf()) where {B} = B

"""
    str(m::MarkerStyle)

Internal function to help in the specific case where a line with markers of different
color than the line is required. In that case a subroutine has to be written to help
GLE, see [`add_sub_marker!`](@ref).
"""
str(m::MarkerStyle) = "$(m.marker)_$(col2str2(m.color))"


"""
    palette(v::Vector{Color})

Set the default palette. To see the current one, write `GPlot.GP_ENV["PALETTE"]` in the REPL.
"""
set_palette(v::Vector{<:Color}) = (GP_ENV["PALETTE"] = v; GP_ENV["SIZE_PALETTE"] = length(v); ∅)
