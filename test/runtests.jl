using GPlot; include("_test.jl")

include("utils.jl")

include("figure.jl")
include("ax.jl")
include("ax_elem.jl")
include("legend.jl")

include("drawing.jl")

include("style.jl")

include("layout.jl")
include("render.jl")

include("properties.jl")

include("object.jl")

continuous_preview(_bk_cont_preview)
G.GP_ENV["PALETTE"] = _bk_palette
G.GP_ENV["SIZE_PALETTE"] = _bk_palette
