function set_text!(::Type{GLE}, obj, elem, v)
   v isa AbstractString || throw(OptionValueError("text", v))
   setfield!(getfield(obj, elem), :text, v)
   return
end

set_text!(g, e::Title, v) = set_text!(g, e, :title, v)


function set_prefix!(::Type{GLE}, obj, v)
   v isa String || throw(OptionValueError("prefix", v))
   v = lowercase(v)
   v ∈ ["x", "x2", "y", "y2", "z"] || throw(OptionValueError("prefix", v))
   v.prefix = v
   return
end


# switch something on or off
function set_off!(::Type{GLE}, obj, v)
   v isa Bool || throw(OptionValueError("off", v))
   obj.off = v
end


# vertical distance of text to axis
function set_dist!(::Type{GLE}, obj, v)
   ((v isa Real) && v ≥ 0.) || throw(OptionValueError("dist", v))
   obj.dist = v
   return
end


# figure size, tuple (width, height)
function set_size!(::Type{GLE}, obj, v)
   (v isa Tuple{<:Real, <:Real}) || throw(OptionValueError("size", v))
   w, h = v
   (w ≥ 0.) && (h ≥ 0.) || throw(OptionValueError("size", v))
   obj.size = v
end

# --------------------
# TICKSLABELS
# --------------------

# rotation angle of tick labels
function set_angle!(::Type{GLE}, obj, v)
   (v isa Real) || throw(OptionValueError("angle", v))
   obj.angle = v
   return
end


# a number format for tick labels
function set_format!(::Type{GLE}, obj, v)
   throw(NotImplementedError("GLE/set_format!"))
end


# shift the tick labels (positive or negative)
function set_shift(::Type{GLE}, obj, v)
   (v isa Real) ||  throw(OptionValueError("shift", v))
   obj.shift = v
   return
end


# set tick labels
function set_names!(::Type{GLE}, obj, v)
   (v isa Vector{<:AbstractString}) || throw(OptionValueError("names", v))
   obj.names = v
   return
end

# --------------------
# AXES2D
# --------------------

# uses a (0,0) centered axis (as opposed to bottom left)
function set_math!(::Type{GLE}, obj, v)
   (v isa Bool) || throw(OptionValueError("math", v))
   obj.math = ifelse(v, true, nothing)
   return
end

# --------------------
# FIGURE
# --------------------

"""
   set_texlabels!

Sets a bool variable indicating whether the figure has LaTex labels or not.
"""
function set_texlabels!(::Type{GLE}, obj, v)
   (v isa Bool) || throw(OptionValueError("texlabels", v))
   obj.texlabels = ifelse(v, true, nothing)
   return
end


"""
   set_texscale!

Sets a string variable indicating the type of scaling (`fixed`, `scale` or `none`)
* `fixed`: keep LaTeX in std size as close as possible to the ambient fontsize
* `scale`: force LaTeX to use a size corresponding to the ambient fontsize
* `none`: do not scale LaTeX.
"""
function set_texscale!(::Type{GLE}, obj, v)
   (v ∈ GLE_TEXSCALE) || throw(OptionValueError("texscale", v))
   obj.texscale = v
   return
end


"""
   set_texpreamble!

Sets the tex preamble that should be used (e.g. with font packages or symbol
packages). Bear in mind that only `pdflatex` can be used and so not all font
packages can be used nor some commands like `fontspec` which are meant for
XeLaTeX or LuaLaTex.
"""
function set_texpreamble!(::Type{GLE}, obj, v)
   (v isa AbstractString) || throw(OptionValueError("texpreamble", v))
   obj.texpreamble = v
   return
end


"""
   set_transparency!

Sets a bool variable corresponding to whether to use cairo (allow transparency)
or not. This is for instance useful if some of the fill colors used are
transparent.
"""
function set_transparency!(::Type{GLE}, obj, v)
   (v isa Bool) || throw(OptionValueError("transparency", v))
   obj.transparency = v
   return
end
