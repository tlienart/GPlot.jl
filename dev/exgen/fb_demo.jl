x = range(0, stop=1, length=100)
y1 = @. x^1.5
y2 = @. x^5
z1 = @. x^(1/1.5)
z2 = @. x^(1/5)
fill_between(x, y1, y2, fill="cornflowerblue", alpha=0.2)
fill_between!(x, z2, z1, fill="seagreen", alpha=0.2)
a1 = x.^3
a2 = x.^(1/3)
plot!(x, a1, lw=0.05, color="cornflowerblue")
plot!(x, a2, lw=0.05, color="seagreen")
fill_between!(x, x, a1, color="red", alpha=0.2)
fill_between!(x, x, a2, color="orange", alpha=0.2)
plot!(x, x, color="black")
plot!(x, z1, color="orange", ls="--")
plot!(x, y1, color="red", ls="--")
