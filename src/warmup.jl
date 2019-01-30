GP_ENV["VERBOSE"] && print("Warming up...")

t = @elapsed begin
    f = Figure("warmup", latex=true, alpha=true)

    ####
    #### Plot warmup
    ####

    x = [1, 2]
    y = [1, 2]
    plot(x, y, color="blue", lwidth=0.02, marker="o", label="plot1")

    ####
    #### Axis/Axes warmup
    ####

    xtitle(tex"$x$"); ytitle(tex"$y$"); title("warmup")
    xlim(0, 5); ylim(0, 5)
    legend()

    gca(); gcf();

    ####
    #### Hist, Bar warmup
    ####

    x = randn(50);
    hist(x, fill="blue", color="blue", scaling="pdf")
y = [10, 20, 15, 50]
    bar(y, fill="red", color="orange", horiz=true)
end; println(" [done, $(round(t, digits=1))s]")
