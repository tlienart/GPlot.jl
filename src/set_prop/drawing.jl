####
#### Scatter2D
####

# label of a drawing (cf legend)
set_label!(o::Scatter2D, v::Union{String, Vector{String}}) = (o.label = v; o)

####
#### Legend
####

# position of the legend (for GLE backend)
function set_position!(o::Legend, v::String)
   @assert get_backend() == GLE "position/only GLE backend supported"
   o.position = get(GLE_LEGEND_POS, v) do
      throw(OptionValueError("position", v))
   end
   return o
end

####
#### Hist2D / Bar
####

set_bins!(o::Hist2D, v::Int) = (o.bins = v; o)

function set_scaling!(o::Hist2D, v::String)
   o.scaling = get(HIST2D_SCALING, v) do
         throw(OptionValueError("lstyle", v))
   end
   return o
end

set_horiz!(o::Union{Hist2D, GroupedBar2D}, v::Bool) = (o.horiz = v; o)

####
#### Fill2D
####

set_xmin!(o::Fill2D, v::Real) = (o.xmin = v; o)
set_xmax!(o::Fill2D, v::Real) = (o.xmax = v; o)

####
#### GroupedBar2D
####

set_stacked!(o::GroupedBar2D, v::Bool) = (o.stacked = v; o)
