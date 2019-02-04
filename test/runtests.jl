using GPlot, Colors, Test; include("_test.jl")

include("utils.jl")

# ✓ 01 feb 19 [/, types/, set_prop/]
# 🚫 [apply_gle]
include("figure.jl")

# ✓ XXX feb 19 [/, types/] (no set_prop)
# XXX [apply_gle]
include("ax.jl")

# ✓ XXX feb 19 [/, types/, set_prop]
# XXX [apply_gle]
include("ax_elem.jl")

# ✓ 03 feb 19 [/, types/, set_prop]
# 🚫 [apply_gle]
include("drawing.jl")

# ✓ 03 feb 19 [types/, set_prop/] (no /)
# 🚫 [apply_gle]
include("style.jl")
