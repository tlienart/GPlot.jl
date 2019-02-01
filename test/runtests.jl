using GPlot, Colors, Test

# ✓ 01 feb 19 [/, types/, set_prop/]
# 🚫 [apply_gle]
include("figure.jl")

# ✓ 01 feb 19 [/, types/] (no set_prop)
# 🚫 [apply_gle]
include("ax.jl")

# ✓ 01 feb 19 [/, types/] (no set_prop)
# 🚫 [set_prop, apply_gle]
include("ax_elem.jl")

# include("axis-axes-gle.jl")
# include("drawings-gle.jl")
