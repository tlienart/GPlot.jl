# label of a drawing (cf legend)
function set_label!(::Type{GLE}, obj, v)
   v isa AbstractString || throw(OptionValueError("label", v))
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
