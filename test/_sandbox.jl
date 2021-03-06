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




text!("hello", (3, -2))

text!("goodbye", (5, 0), font="tt")

text!("another-one", (5, -1), fontsize=0.8)

text!("blah", (3, 0))

clo!()

# so it's preserved, not good

debug_gle(gcf())

################################
################################

continuous_preview(true)

clf()

θ = range(-4pi, 4pi, length=200);
z = range(-2, 2, length=200);
r = z.^2 .+ 1;
x = r .* sin.(θ);
y = r .* cos.(θ);

xx = 4 * ones(10)
yy = range(-4,4,length=10)
zz = 0*yy .- 2

xx2 = range(-4,4,length=10)
yy2 = 4 * ones(10)
zz2 = 0*yy2 .- 2

#cla()

plot3(x,y,z, marker=".", msize=.2, mcol="red")
# plot3!(xx,yy,zz)
# plot3!(xx2,yy2,zz2)


plot3(x,y,z, marker=".", msize=0.01, mcol="salmon")

plot(y,z)

preview()

plot(x, y)
