#### plot with range

using GPlot
#using ColorBrewer

f = Figure()
x = range(1, 5, length=100)
y1 = @. exp(-sin(x)/x^2)
y2 = @. exp(cos(x)/x)
plot(x, y1, y2; lwidth=0.05)
scatter!(x, 0.5.+(y1.-y2)./10, msize=0.1)
legend()

preview()

#savefig(f, format="pdf", path="/Users/tlienart/Desktop/")

GPlot.debug_gle(f)
