# label of a drawing (cf legend)
set_label!(::Type{GLE}, obj, v::Union{AS, Vector{<:AS}}) = (obj.label = v)

# position of the legend
function set_position!(::Type{GLE}, leg::Legend, v::String)
   leg.position = get(GLE_LEGEND_POS, v) do
      throw(OptionValueError("position", v))
   end
end

####
#### Hist2D
####

set_bins!(::Type{GLE}, obj::Hist2D, v::Int) = (obj.bins = v)

function set_scaling!(::Type{GLE}, obj::Hist2D, v::String)
   obj.scaling = get(GLE_HIST2D_SCALING, v) do
         throw(OptionValueError("lstyle", v))
   end
end

set_fill!(g, obj, v) = set_color!(g, obj, :barstyle, v; name=:fill)

set_horiz!(::Type{GLE}, obj, v::Bool) = (obj.barstyle.horiz = v)

####
#### Fill2D
####

set_xmin!(::Type{GLE}, obj, v::Real) = (obj.xmin = x)

set_xmax!(::Type{GLE}, obj, v::Real) = (obj.xmax = x)
