# percentages
data = [30 40 30; 50 25 25; 30 30 40; 10 50 40]
# cumulative sum so that columns increase
data_cs = copy(data);
data_cs[:,2] = data_cs[:,1]+data_cs[:,2]
data_cs[:,3] .= 100
bar(data_cs; stacked=true, fills=["midnightblue", "lightseagreen", "lightsalmon"])
