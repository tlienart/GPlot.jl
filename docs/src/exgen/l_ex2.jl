x = range(0, stop=π/2, length=100)
d1 = plot(x, sin.(x), lw=0.05)
d2 = plot!(x, cos.(x), lw=0.05)
fill_between!(x, sin.(x), cos.(x), alpha=0.2)
x = x[1:5:end]
d3 = scatter!(x, sin.(x) .* cos.(x), msize=0.3, marker="fdiamond")
legend([d1, d2, d3], ["sine", "cosine", "scatter"])
xlim(0,π/2)
