x = range(-2, stop=2, length=20)
y1 = @. sin(exp(-x)) + 0.5
y2 = @. sin(exp(-x)) - 0.5
plot(x, y1; label="unsmoothed")
plot!(x, y2; smooth=true, label="smoothed")
legend()
