"""
   set_size!

Sets a tuple indicating width,height size of the figure.
"""
function set_size!(::Type{GLE}, obj, v::Tuple{<:Real, <:Real})
   w, h = v
   (w ≥ 0.) && (h ≥ 0.) || throw(OptionValueError("size", v))
   obj.size = v
end


"""
   set_texlabels!

Sets a bool variable indicating whether the figure has LaTex labels or not.
"""
set_texlabels!(::Type{GLE}, obj, v::Bool) = (obj.texlabels = ifelse(v, v, ∅))

"""
   set_texscale!

Sets a string variable indicating the type of scaling (`fixed`, `scale` or `none`)
* `fixed`: keep LaTeX in std size as close as possible to the ambient fontsize
* `scale`: force LaTeX to use a size corresponding to the ambient fontsize
* `none`: do not scale LaTeX.
"""
function set_texscale!(::Type{GLE}, obj, v::String)
   (v ∈ GLE_TEXSCALE) || throw(OptionValueError("texscale", v))
   obj.texscale = v
end


"""
   set_texpreamble!

Sets the tex preamble that should be used (e.g. with font packages or symbol
packages). Bear in mind that only `pdflatex` can be used and so not all font
packages can be used nor some commands like `fontspec` which are meant for
XeLaTeX or LuaLaTex.
"""
set_texpreamble!(::Type{GLE}, obj, v::AbstractString) = (obj.texpreamble = v)


"""
   set_transparency!

Sets a bool variable corresponding to whether to use cairo (allow transparency)
or not. This is for instance useful if some of the fill colors used are
transparent.
"""
set_transparency!(::Type{GLE}, obj, v::Bool) = (obj.transparency = v)
