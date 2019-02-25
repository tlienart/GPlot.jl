####
#### Scatter2D
####

# label of a drawing (cf legend)
function set_labels!(o::Scatter2D, v::Vector{String})
      length(v) == o.nobj || throw(DimensionMismatch("labels // dimensions don't match"))
      o.labels = v
      return nothing
end
set_labels!(o::Scatter2D, s::String) = set_labels!(o, fill(s, length(o.linestyles)))

####
#### Hist2D / Bar
####

set_bins!(o::Hist2D, v::Int) = (o.bins = v)

function set_scaling!(o::Hist2D, v::String)
   o.scaling = get(HIST2D_SCALING, v) do
         throw(OptionValueError("lstyle", v))
   end
   return nothing
end

set_horiz!(o::Union{Hist2D, Bar2D}, v::Bool) = (o.horiz = v)

####
#### Fill2D
####

set_xmin!(o::Fill2D, v::Float64) = (o.xmin = v)
set_xmax!(o::Fill2D, v::Float64) = (o.xmax = v)

####
#### Bar2D
####

set_stacked!(o::Bar2D, v::Bool) = (o.stacked = v)
