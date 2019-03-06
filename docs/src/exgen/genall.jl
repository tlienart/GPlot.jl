using GPlot

continuous_preview(false)

function gen(s::String; format="svg")
    include(s*".jl")
    savefig(gcf(), s; format=format, path=joinpath(@__DIR__, "out"))
end

# quickstart
gen("qs_ex1")
gen("qs_ex2")
