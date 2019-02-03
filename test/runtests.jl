using GPlot, Colors, Test; const G = GPlot

include("utils.jl")

# ✓ 01 feb 19 [/, types/, set_prop/]
# 🚫 [apply_gle]
include("figure.jl")

# ✓ 01 feb 19 [/, types/] (no set_prop)
# 🚫 [apply_gle]
include("ax.jl")

# ✓ 02 feb 19 [/, types/, set_prop]
# 🚫 [apply_gle]
include("ax_elem.jl")

# ✓ 03 feb 19 [/, types/, set_prop]
# 🚫 [apply_gle]
include("drawing.jl")

# ✓ 03 feb 19 [types/] (no /)
# 🚫 [apply_gle, set_prop]
include("style.jl")
