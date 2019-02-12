"""
   set_size!(o, t)

Sets a tuple indicating (width, height) size of the figure.
"""
set_size!(o::Figure, t::NTuple{2,Float64}) = (o.size = t; o)

"""
   set_texlabels!(o, v)

Sets a bool variable indicating whether the figure has LaTex labels or not.
"""
set_texlabels!(o::Figure, v::Bool) = (o.texlabels = ifelse(v, v, ∅); o)

"""
   set_texscale!(o, v)

Sets a string variable indicating the type of scaling (`fixed`, `scale` or `none`)
* `fixed`: keep LaTeX in std size as close as possible to the ambient fontsize
* `scale`: force LaTeX to use a size corresponding to the ambient fontsize
* `none`: do not scale LaTeX.
"""
function set_texscale!(o::Figure, v::String)
   @assert get_backend() == GLE "texscale/only GLE backend supported"
   (v ∈ GLE_TEXSCALE) || throw(OptionValueError("texscale", v))
   o.texscale = v
   return o
end


"""
   set_texpreamble!

Sets the tex preamble that should be used (e.g. with font packages or symbol
packages). Bear in mind that only `pdflatex` can be used and so not all font
packages can be used nor some commands like `fontspec` which are meant for
XeLaTeX or LuaLaTex.
"""
set_texpreamble!(o::Figure, v::String) = (o.texpreamble = v; o)


"""
   set_transparency!

Sets a bool variable corresponding to whether to use cairo (allow transparency)
or not. This is for instance useful if some of the fill colors used are
transparent.
"""
set_transparency!(o::Figure, v::Bool) = (o.transparency = v; o)
