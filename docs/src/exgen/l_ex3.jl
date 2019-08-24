x = randn(100)
hist(x, nbins=10, norm="pdf", label="hist")
plot!(x->exp(-x^2/2)/√(2π), -3, 3, label="fit", smooth=true)
legend()
