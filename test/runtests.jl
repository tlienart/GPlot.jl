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

# XXX  ongoing
include("drawing.jl")
