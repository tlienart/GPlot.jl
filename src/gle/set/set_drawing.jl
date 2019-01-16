# label of a drawing (cf legend)
function set_label!(::Type{GLE}, obj, v)
   v isa Union{AbstractString, Vector{String}} || throw(OptionValueError("label", v))
   obj.label = v
   return
end

# position of the legend
function set_position!(::Type{GLE}, leg::Legend, v)
   leg.position = get(GLE_LEGEND_POS, v) do
      throw(OptionValueError("position", v))
   end
   return
end

####
#### Hist2D
####

function set_bins!(::Type{GLE}, obj::Hist2D, v)
   v isa Int || throw(OptionValueError("nbins", v))
   obj.bins = v
   return
end

function set_scaling!(::Type{GLE}, obj::Hist2D, v)
   obj.scaling = get(GLE_HIST2D_SCALING, v) do
         throw(OptionValueError("lstyle", v))
   end
   return
end

set_fill!(g, obj, v) = set_color!(g, obj, :histstyle, v; name=:fill)

function set_horiz!(::Type{GLE}, obj, v)
   v isa Bool || throw(OptionValueError("horiz", v))
   obj.histstyle.horiz = v
   return
end
