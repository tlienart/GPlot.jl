x = range(0, stop=1, length=100)
y = x.^2
fill_between(x, y, x; color="orchid", alpha=0.2)
fill_between!(x, 0.5, 0.6; from=0.4, to=0.9, alpha=0.2)
style = (color="darkslategray", ls="--", lw=0.01)
hline(0.5; style...)
hline(0.6; style...)
vline(0.4; style...)
vline(0.9; style...)
