y2 = @. sin(x^2) * exp(-x/10)
plot!(x, y2, col="blue", lwidth=0.05, label="plot 2")

xlabel("x-axis")
ylabel("y-axis")
xticks([-pi/2, 0, pi/2], ["π/2", "0", "π/2"])
ylim(-1.5, 1.5)
yticks(-1:0.25:1)

legend()
