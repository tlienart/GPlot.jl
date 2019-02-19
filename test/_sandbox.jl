#### plot with range

using GPlot

#############################################################
######################### should be in the ~3 seconds range.
t = @elapsed begin
    tempdir = mktempdir()
    f = Figure("___")
    x, y = [1, 2], [3, 4]
    x2 = range(1, stop=2, length=10)
    y2 = exp.(x2)
    # -- plot
    plot(x, y); plot(x, y, ls="--", lw=0.1, color="blue", label="label1")
    plot!(x2, y2, lwidth=0.02)
    xlabel("xlabel"); ylabel("ylabel"); title("title")
    legend(pos="tl", fontsize=7)
    xticks([1, 2], ["a", "b"]); yticks([1, 2], ["a", "b"])
    xscale("lin"); yscale("lin")
    xlim(min=0,max=5); ylim(min=0,max=5)
    GPlot.assemble_figure(f)
    savefig(f, res=100, format="png", path=tempdir)
    # -- hist
    GPlot.destroy(f)
    f = Figure()
    x = rand(10)
    hist(x, fill="cornflowerblue", color="white", scaling="pdf", nbins=50)
    bar(x, x, 2x; stacked=true, fills=["blue","red"], colors=["red","blue"])
    GPlot.assemble_figure(f)
    # if there's a working GLE backend, warm that up too
    savefig(f, format="pdf", path=tempdir)
    # clear everything
    GPlot.destroy(f)
end; println(".............done in $(round(t, digits=1))s ✅")
#############################################################
#############################################################

f = Figure()

x = [1, 2, 3, 4, 5, 6, 7]
y = [1, 4, missing, 16, 25, missing, 10]

plot(x, y)

preview()

x = randn(500)
xm = convert(Vector{GPlot.CanMiss{Float64}}, x)

hist(xm)

preview()

# NOTE could not directly read single column file so would only be partial support
# so folks would have to readdlm and then hist...
f = Figure()
plot(:c1, :c2, path=joinpath(@__DIR__, "_filetest.csv"), lwidth=0.05)

preview()

#savefig(f, format="pdf", path="/Users/tlienart/Desktop/")


preview()

GPlot.debug_gle(f)
