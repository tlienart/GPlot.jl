x = range(0, stop=π, length=100)
y1 = 0
y2 = @. cos(5x)*exp(-x)
plot(x, y2, lw=0.05)
fill_between!(x, y1, y2, fill="aliceblue")
hline(y1)
xlim(0, π)
