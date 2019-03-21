n = 300
x = randexp(n)
hist(x, nbins=30, fill="lemonchiffon", ecol="navy", norm="pdf")
plot!(x->exp(-x), 0, maximum(x), lw=0.05)
