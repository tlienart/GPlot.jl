using GPlot, Colors, Test

# ----

# ✓ 01 feb 19 [/, types/, set_prop/]
# 🚫 [apply_gle]
include("figure.jl")

# ✓ 01 feb 19 [/, types/] (no set_prop)
# 🚫 [apply_gle]
include("ax.jl")

# ✓ 02 feb 19 [/, types/, set_prop]
# 🚫 [apply_gle]
include("ax_elem.jl")

# ✓ 02 feb 19 [types/]
# 🚫 [/, apply_gle, set_prop]
include("drawing.jl")
