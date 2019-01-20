# label of a drawing (cf legend)
set_label!(::Type{GLE}, o, v::Union{AS, Vector{<:AS}}) = (o.label = v; o)

# position of the legend
function set_position!(::Type{GLE}, o::Legend, v::String)
   o.position = get(GLE_LEGEND_POS, v) do
      throw(OptionValueError("position", v))
   end
   return o
end

####
#### Hist2D
####

set_bins!(::Type{GLE}, o::Hist2D, v::Int) = (o.bins = v; o)

function set_scaling!(::Type{GLE}, o::Hist2D, v::String)
   o.scaling = get(GLE_HIST2D_SCALING, v) do
         throw(OptionValueError("lstyle", v))
   end
   return o
end

set_horiz!(::Type{GLE}, o, v::Bool) = (o.horiz = v; o)

####
#### Fill2D
####

set_xmin!(::Type{GLE}, o::Fill2D, v::Real) = (o.xmin = x; o)
set_xmax!(::Type{GLE}, o::Fill2D, v::Real) = (o.xmax = x; o)

####
#### GroupedBar2D
####

set_stacked!(::Type{GLE}, o::GroupedBar2D, v::Bool) = (o.stacked = v; o)
