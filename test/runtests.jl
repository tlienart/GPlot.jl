using GPlot, Test

# XXX
begin
    f = Figure()
    #erase!(f)

    x1 = range(-2, stop=2, length=100)
    y1 = @. exp(-x1 * sin(x1))
    y2 = @. exp(-x1 * cos(x1))
    x2 = range(0, stop=2, length=10)
    y3 = @. sqrt(x2)
    y4 = @. exp(sin(x1)-x1^2)*x1
    x3 = range(-1, stop=1, length=15)
    y5 = @. x3^2
    y6 = @. -y5+1

    plot!(x1, y1, color="darkblue", lwidth=0.02, lstyle=3)
    plot!(x1, y2, color="indianred")
    plot!(x2, y3, lstyle="none", marker="fcircle", msize=0.1, color="#0c88c2")
    plot!(x1, y4, color="#76116d", lwidth=0.1)
    plot!(x3, y5, ls="-", color="orange", lwidth=0.05, marker="o", mcol="red")
    plot!(x3, y6, ls="-", color="orange", lwidth=0.05, marker="•", mcol="red")

    xtitle!("x-axis")
    x2title!("x2-axis")
    y2title!("y2-axis")
    ytitle!("y-axis")
    title!("The title")
    GPlot.assemble_figure(f)
end
#run(`bash -c "$(GPlot.GLE_APP_PATH)/gle -d png -vb 0 -r 200 $(GPlot.GP_TMP_PATH)/$(f.id).gle $(GPlot.GP_TMP_PATH)/$(f.id).png"`)

f

isdefined(Main, :Atom)

# XXX
###########

# XXX temporary fill in
