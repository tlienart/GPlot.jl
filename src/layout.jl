"""
    layout(f, anchors)

Describes a custom grid layout allowing to specify where the axes origin should
be and how big (all relative to width/height of the figure). The `anchors` matrix
is a `n × 4` matrix where `n` is the total number of axes. The first two columns
indicate the relative position of the origin (so that the actual position is
`(anchors[k,1]W, anchors[k,2]H)` where `W,H=gcf().size`). The last two
columns indicate the size of the axes.

# Examples
```jl
julia> layout(f, [0.1 0.1 0.3 0.3;  # origin = (0.1W,0.1H)
                   0.1 0.5 0.3 0.3]) # size = (0.3W, 0.3H)
```
"""
function layout(f::Figure{B}, anchors::Matrix{Float64}) where B<:Backend
    #  ______________________
    # |                      |
    # |  X    Y    W    H    |
    # |______________________|
    size(anchors, 2) == 4 || throw(ArgumentError("anchors must be of size ((nrows*ncols) × 4)"))
    all(0 .<= anchors .<= 1) || throw(ArgumentError("layout relative anchors must be between 0 and 1"))

    erase!(f)
    W, H = f.size
    # fill with Axes2D, if later there are axes3D it will just replace
    for i ∈ 1:size(anchors, 1)
        add_axes!(f, Axes2D{B}(origin=(anchors[i, 1]*W, anchors[i, 2]*H),
                                 size=(anchors[i, 3]*W, anchors[i, 4]*H)))
    end
    return preview()
end

"""
    subplot(a, b, c)
    subplot(abc)

Describe an automatic grid layout of axes of size `a × b` and selects axes `c`.
The axes are counted from the top left (1) increasing towards the right and the bottom.

# Examples
```jl
julia> subplot(222) # `2×2` grid layout, select top-right axes
julia> subplot(224) # selects bottom-right axes.
```

See also: [`layout`](@ref) to specify a custom layout.
"""
function subplot(nrows::Int, ncols::Int, idx::Int)
    1 <= nrows <= 9 || throw(ArgumentError("nrows must be between 1 and 9"))
    1 <= ncols <= 9 || throw(ArgumentError("ncols must be between 1 and 9"))
    1 <= idx <= nrows*ncols || throw(ArgumentError("idx must be between 1 and $(nrows*ncols)"))

    f = gcf()
    W, H = f.size
    wh_ratio = W/H
    # 1. if there are no axes in the current figure, add them
    if isempty(f.axes)
        # default layout is a grid
        #  ______________________
        # |                      |
        # | a1     a2     a3     |
        # |                      |
        # |                      |
        # | a4     a5     a6     |
        # |______________________|

        # this has been hand-tuned to give acceptable results for
        # (1, 2, 3) x (1, 2, 3). Beyond that is likely too cramped

        v_rel = 0.2 * wh_ratio * (1 + 0.2*(nrows-1))  # relative vertical margin
        vbox  = 1.0 / (nrows * (1.0 + v_rel) + v_rel) # relative vertical box size
        h_rel = 0.2 * (1 + 0.2*(ncols-1))             # relative horizontal margin
        hbox  = 1.0 / (ncols * (1.0 + h_rel) + h_rel) # relative horizontal boxsize

        vbox_m  = vbox * v_rel
        hbox_m  = hbox * h_rel
        vbox_wm = vbox + vbox_m
        hbox_wm = hbox + hbox_m
        hard_bottom = 0.01 * wh_ratio
        hard_left   = 0.01

        grid = zeros(nrows*ncols, 4)
        k = 1
        for r ∈ 1:nrows
            for c ∈ 1:ncols
                # increasing left to right
                # decreasing top to bottom
                grid[k, 1] = hard_left + hbox_m + (hbox_wm * (c-1)) # increasing left to right
                grid[k, 3] = hbox
                grid[k, 2] = hard_bottom + 1.0 - vbox_wm * r
                grid[k, 4] = vbox
                k += 1
            end
        end
        layout(f, grid)
    # 2. if there are axes, check that it matches, if it doesn't
    else
        length(f.axes) == nrows*ncols || throw(ArgumentError("the layout description does not " *
                              "match the current axes. If you want to change the layout of " *
                              "the current figure use `clf()` first to remove the existing axes."))
    end
    # 3. select the relevant axes and make them the current ones
    curax = f.axes[idx]
    GP_ENV["CURAXES"] = curax
    return nothing
end

function subplot(d::Int)
    111 <= d <= 999 || throw(ArgumentError("invalid description for the layout"))
    nrows = div(d, 100)
    dd    = d - 100nrows
    ncols = div(dd, 10)
    idx   = dd - 10ncols
    subplot(nrows, ncols, idx)
end
