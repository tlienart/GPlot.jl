using GPlot, Colors, Test; include("_test.jl")

include("utils.jl")

# ✓ 01 feb 19 [/, types/, set_prop/]
# 🚫 [apply_gle]
include("figure.jl")

# ✓ 04 feb 19 [/, types/, apply_gle/] (no set_prop)
include("ax.jl")

# ✓ 04 feb 19 [/, types/, set_prop, apply_gle/]
include("ax_elem.jl")

# ✓ 09 feb 19 [/, types/, set_prop]
# 🚫 [apply_gle]
include("drawing.jl")

# ✓🚫 09 feb 19 [types/, set_prop/, apply_gle/] (no /)
include("style.jl")
