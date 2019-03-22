x = range(0, stop=1, length=20)
plot(x, x.^2, x.^3, lw=0.05, ls=["--", "-"], marker=["wo", "none"],
     keys=["quadratic", "cubic"],)
scatter!(x, sin.(x), key=["sine"])
legend(; position="top-left")
