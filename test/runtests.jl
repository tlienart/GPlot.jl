using GPlot, Colors, Test

# legacy
isdefined(Base, :isnothing) || (isnothing(o) = o === nothing)

# ----

# ✓ 01 feb 19 [/, types/, set_prop/]
# 🚫 [apply_gle]
include("figure.jl")

# ✓ 01 feb 19 [/, types/] (no set_prop)
# 🚫 [apply_gle]
include("ax.jl")

# ✓ 01 feb 19 [/, types/] (no set_prop)
# XXX ONGOING: set_prop (up to set_format!)
# 🚫 [set_prop, apply_gle]
include("ax_elem.jl")

# include("axis-axes-gle.jl")
# include("drawings-gle.jl")
