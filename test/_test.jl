using Colors, DelimitedFiles, Test, Statistics, Random
const G = GPlot

isin(s, str) = @test occursin(str, s)
notisin(s, str) = @test !occursin(str, s)

# disable continuous preview in tests
_bk_cont_preview = G.GP_ENV["CONT_PREVIEW"]
_bk_palette = G.GP_ENV["PALETTE"]
continuous_preview(false)

if VERSION < v"1.1"
    eachrow(A::AbstractArray) = (view(A, j, :) for j ∈ axes(A, 1))
end

function m2b(a,b)
    ismissing(a) && ismissing(b) && return true
    isinf(a) && isinf(b) && return true
    isnan(a) && isnan(b) && return true
    return (a == b)
end

function checkzip(z, v::VecOrMat)
    for (zi, vi) ∈ zip(z, eachrow(v))
      all(m2b(zi[j], vi[j]) for j ∈ eachindex(vi)) || (@show zi; @show vi; return false)
    end
    return true
end
