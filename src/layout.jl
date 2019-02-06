function layout!(f::Figure{B}, anchors=Matrix{Float64}) where B<:Backend
    @assert size(anchors, 2) == 4 "anchors must be of size ((nrows*ncols) × 4)"
    @assert all(0 .<= anchors .<= 1) "layout relative anchors must be between 0 and 1"

    erase!(f)
    W, H = f.size
    # fill with Axes2D, if later there are axes3D it will just replace
    for i ∈ 1:size(anchors, 1)
        add_axes!(f, Axes2D{B}(origin=(anchors[i, 1]*W, anchors[i, 2]*H),
                               size=(anchors[i, 3]*W, anchors[i, 4]*H),
                               title=Title()))
    end
    @show f.axes[1].origin
    return f
end

# synonym
layout(f, anchors) = layout!(f, anchors)

function subplot(nrows::Int, ncols::Int, idx::Int)
    @assert 1 <= nrows <= 9 "nrows must be between 1 and 9"
    @assert 1 <= ncols <= 9 "ncols must be between 1 and 9"
    @assert 1 <= idx <= nrows*ncols "idx must be between 1 and $(nrows*ncols)"

    f = gcf()
    # 1. if there are no axes in the current figure, add them
    if isempty(f)
        # default layout is a grid
        #  ______________________
        # |                      |
        # | a1     a2     a3     |
        # |                      |
        # |                      |
        # | a4     a5     a6     |
        # |______________________|

        vbox = 1/nrows
        voff = 0 # vbox/10
        hbox = 1/ncols
        hoff = 0 # hbox/10

        grid = zeros(nrows*ncols, 4)
        k = 1
        for r ∈ 1:nrows
            for c ∈ 1:ncols
                grid[k, 1] = (hbox * (c-1)) + hoff   # increasing left to right
                grid[k, 3] = hbox - hoff             # width of graph
                grid[k, 2] = 1.0 - (vbox * r) + voff # decreasing top to bottom
                grid[k, 4] = vbox - voff             # heigth of graph
                k += 1
            end
        end
        layout!(f, grid)
        @show "B4"
        @show f.axes[1].origin
    # 2. if there are axes, check that it matches, if it doesn't
    else
        @assert length(f.axes) == nrows*ncols "the layout description does not match the " *
                        "current axes. If you want to change the layout of the current " *
                        "figure use erase!(gcf()) first to remove the existing axes."
    end
    @show "AFTER"
    @show f.axes[1].origin

    # 3. select the relevant axes and make them the current ones
    curax = f.axes[idx]
    GP_ENV["CURAXES"] = curax
    return curax
end

function subplot(d::Int)
    @assert 111 <= d <= 999 "invalid description for the layout"
    nrows = div(d, 100)
    dd    = d - 100nrows
    ncols = div(dd, 10)
    idx   = dd - 10ncols
    subplot(nrows, ncols, idx)
end
