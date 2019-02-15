####
#### Scatter2D
####

# label of a drawing (cf legend)
function set_labels!(o::Scatter2D, v::Vector{String})
      if length(v) != length(o.linestyle)
         throw(OptionValueError("labels // dimensions don't match", v))
      end
      o.label = v
      return o
end
set_labels!(o::Scatter2D, s::String) = set_labels!(o, fill(s, length(o.linestyle)))

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

set_horiz!(o::Union{Hist2D, Bar2D}, v::Bool) = (o.horiz = v; o)

####
#### Fill2D
####

set_xmin!(o::Fill2D, v::Float64) = (o.xmin = v; o)
set_xmax!(o::Fill2D, v::Float64) = (o.xmax = v; o)

####
#### Bar2D
####

set_stacked!(o::Bar2D, v::Bool) = (o.stacked = v; o)