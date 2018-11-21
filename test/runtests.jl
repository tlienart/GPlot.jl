using GPlot, Test

# XXX
f = Figure()
#erase!(f)

x1 = range(-2, stop=2, length=100)
y1 = @. exp(-x1 * sin(x1))
y2 = @. exp(-x1 * cos(x1))
x2 = range(0, stop=2, length=10)
y3 = @. sqrt(x2)
y4 = @. exp(sin(x1)-x1^2)*x1

plot!(x1, y1, color="darkblue", lwidth=0.02, lstyle=2)
plot!(x1, y2, color="indianred")
plot!(x2, y3, marker="fcircle", msize=0.1, color="#0c88c2")
plot!(x1, y4, color="#76116d", lwidth=0.1)

xtitle!("x-axis")
x2title!("x2-axis")
y2title!("y2-axis")
ytitle!("y-axis")
title!("The title")

GPlot.assemble_figure(f)


# XXX
###########

# XXX temporary fill in
