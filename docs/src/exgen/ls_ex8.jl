x = range(0, 2, length=100)
for α ∈ 0.01:0.05:0.8
    plot!(x, x.^α, lwidth=α/10, col=RGB(0.0,0.0,α), smooth=true)
end
