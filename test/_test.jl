using Colors, DelimitedFiles, Test
const G = GPlot

isin(s, str) = @test occursin(str, s)
notisin(s, str) = @test !occursin(str, s)

continuous_preview(false)

if VERSION < v"1.1"
    eachrow(A::AbstractArray) = (view(A, j, :) for j ∈ axes(A, 1))
end

function checkzip(z, v::VecOrMat)
    for (zi, vi) ∈ zip(z, eachrow(v))
      all(zi[j]==vi[j] for j ∈ eachindex(vi)) || return false
    end
    return true
end
