# label of a drawing (cf legend)
set_label!(::TBK, o, v::Union{AS, Vector{<:AS}}) = (o.label = v; o)

# position of the legend (for GLE backend)
function set_position!(::TGLE, o::Legend, v::String)
   o.position = get(GLE_LEGEND_POS, v) do
      throw(OptionValueError("position", v))
   end
   return o
end

####
#### Hist2D
####

set_bins!(::TBK, o::Hist2D, v::Int) = (o.bins = v; o)

function set_scaling!(::TBK, o::Hist2D, v::String)
   o.scaling = get(HIST2D_SCALING, v) do
         throw(OptionValueError("lstyle", v))
   end
   return o
end

set_horiz!(::TBK, o, v::Bool) = (o.horiz = v; o)

####
#### Fill2D
####

set_xmin!(::TBK, o::Fill2D, v::Real) = (o.xmin = x; o)
set_xmax!(::TBK, o::Fill2D, v::Real) = (o.xmax = x; o)

####
#### GroupedBar2D
####

set_stacked!(::TBK, o::GroupedBar2D, v::Bool) = (o.stacked = v; o)
