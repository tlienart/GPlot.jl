plot(sin, 0, π, label="sine", lw=0.1)
scatter!(cos, 0, π, length=25, label="cosine")
xlim(0, π)
legend(fontsize=12, font="texcmtt", nobox=true, position="bottom-left")
