using Colors
set_palette([c"#ca624b", c"#f7dba7", c"#daddd8", c"#61d095", c"#c7d59f"])
for i in 1:5
    plot!(randn(10), lw=0.05)
end
