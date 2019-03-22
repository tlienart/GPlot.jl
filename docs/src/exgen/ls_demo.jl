cla()
x = range(0, stop=π, length=250)
for α ∈ [1, 4, 7, 10]
    y = @. exp(-√α*x)*sin(2*x/α)*α^2
    plot!(x, y, ls="-", lw=0.05)
end
mx = x[1:10:end]
scatter!(mx, sin.(mx), marker="star", col="salmon", msize=0.3)
xlim(0, π)
