using Colors, DelimitedFiles, Test
const G = GPlot

isin(s, str) = @test occursin(str, s)
notisin(s, str) = @test !occursin(str, s)
