x = randn(500)
hist(x; nbins=50, scaling="pdf")
plot!(x -> exp(-x^2/2)/sqrt(2π), -3, 3)
