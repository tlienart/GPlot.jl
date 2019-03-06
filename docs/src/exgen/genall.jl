using GPlot

continuous_preview(false)

function gen(s::String; format="svg")
    include(s*".jl")
    savefig(gcf(), s; format=format, path=joinpath(@__DIR__, "out"))
end

# quickstart
gen("qs_ex1")
gen("qs_ex2")

# line-scatter
gen("ls_ex1")
gen("ls_ex2")
gen("ls_ex3")
gen("ls_ex4")
gen("ls_ex5")
gen("ls_ex6")
