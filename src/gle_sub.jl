####
#### Subroutines for GLE
####

"""
    add_sub_marker!(f, m)

Internal function to add an appropriate subroutine to the GLE script to deal with markers that
must have a different color than the line they are associated with. For instance if you want a
blue line with red markers, you need to define a specfici subroutine for red-markers otherwise
both line and markers are going to be of the same color.
Note: these subroutines all start with the name `mk_....` (see [`str`](@ref)).
"""
function add_sub_marker!(f::Figure, m::MarkerStyle)
    if str(m) ∉ keys(f.subroutines)
        f.subroutines[str(m)] = """
        sub _$(str(m)) size mdata
        	gsave
            set color $(col2str(m.color))
            marker $(m.marker) 1
        	grestore
        end sub
        define marker $(str(m)) _$(str(m))
        """
    end
    return nothing
end

const GLE_DRAW_SUB = Dict{String,String}()

###############################################################
####
#### Boxplot subroutine
####
###############################################################

const boxplot_box_lstyle = """
    \tset lstyle blstyle lwidth blwidth color blcolor\$
    """
const boxplot_med_lstyle = """
    \tset lstyle medlstyle lwidth medlwidth color medcolor\$
    """
const boxplot_mean_mstyle = """
    \t    gsave
    \t    set color mmcol\$
    \t    marker mmarker\$ mmsize
    \t    grestore
    """

const boxplot_core_vertical = """
    \tgsave
    $boxplot_box_lstyle
    \tamove xg(p-wwidth/2) yg(wlow)
    \taline xg(p+wwidth/2) yg(wlow)
    \tamove xg(p) yg(wlow)
    \taline xg(p) yg(q25)
    \tamove xg(p-bwidth/2) yg(q25) ! bottom left corner
    \tbox xg(p+bwidth/2)-xg(p-bwidth/2) yg(q75)-yg(q25)
    \tamove xg(p) yg(q75)
    \taline xg(p) yg(whigh)
    \tamove xg(p-wwidth/2) yg(whigh)
    \taline xg(p+wwidth/2) yg(whigh)
    \tgrestore

    \tgsave
    $boxplot_med_lstyle
    \tamove xg(p-bwidth/2) yg(q50)
    \taline xg(p+bwidth/2) yg(q50)
    \tgrestore

    \tif (mshow > 0) then
    \t    amove xg(p) yg(mean)
    $boxplot_mean_mstyle
    \tend if
    """

const boxplot_core_horizontal = """
    \tgsave
    $boxplot_box_lstyle
    \tamove xg(wlow) yg(p-wwidth/2)
    \taline xg(wlow) yg(p+wwidth/2)
    \tamove xg(wlow) yg(p)
    \taline xg(q25) yg(p)
    \tamove xg(q25) yg(p-bwidth/2) ! bottom left corner
    \tbox xg(q75)-xg(q25) yg(p+bwidth/2)-yg(p-bwidth/2)
    \tamove xg(q75) yg(p)
    \taline xg(whigh) yg(p)
    \tamove xg(whigh) yg(p-wwidth/2)
    \taline xg(whigh) yg(p+wwidth/2)
    \tgrestore

    \tgsave
    $boxplot_med_lstyle
    \tamove xg(q50) yg(p-bwidth/2)
    \taline xg(q50) yg(p+bwidth/2)
    \tgrestore

    \tif (mshow > 0) then
    \t    amove xg(mean) yg(p)
    $boxplot_mean_mstyle
    \tend if
    """

const boxplot_args = ("p wlow q25 q50 q75 whigh mean ", # NOTE don't forget space at the end
                      "bwidth wwidth blstyle blwidth blcolor\$ ",
                      "medlstyle medlwidth medcolor\$ ",
                      "mshow mmarker\$ mmsize mmcol\$ ")

GLE_DRAW_SUB["bp_vert"] = """
    sub boxplot_vert $(prod(boxplot_args))
        set cap round ! open lines have rounded ends
        $boxplot_core_vertical
    end sub
    """

GLE_DRAW_SUB["bp_horiz"] = """
    sub boxplot_horiz $(prod(boxplot_args))
        set cap round ! open lines have rounded ends
        $boxplot_core_horizontal
    end sub
    """

###############################################################
####
#### Heatmap Subroutine
####
###############################################################

"""
    add_sub_marker!(f, m)

Internal function to add a heatmap subroutine to the GLE script.
"""
function add_sub_heatmap!(f::Figure, hm::Heatmap, hashid::UInt)

    #=
    if zij <= 1 then
        col$ = firstcolor
    else if zij <=2 then
        col$ = secondcolor
    ...
    else
        col$ = missingcolor
    end
    =#
    ifpart = """
        \n\t\tif zij <= 1 then        ! both 0 and 1
            cij\$ = \"$(col2str(hm.cmap[1]))\"
        """
    for k ∈ 2:length(hm.cmap)-1
        ifpart *= """
            \n\t\telse if zij <= $k then
                cij\$ = \"$(col2str(hm.cmap[k]))\"
            """
    end
    ifpart *= """
        \n\t\telse
            cij\$ = \"$(col2str(hm.cmiss))\"
        end if
        """

    boxpart = ifelse(hm.transpose, """
        \t\tamove xg((i-1)*bh) yg(1-j*bw)
        box xg(bh)-xg(0) yg(bw)-yg(0) nobox fill cij\$
        """, """
        \t\tamove xg((j-1)*bw) yg(1-i*bh)
        box xg(bw)-xg(0) yg(bh)-yg(0) nobox fill cij\$
        """)

    f.subroutines["hm_$hashid"] = """
        sub hm_$hashid j ds\$ bw bh
            for i = 1 to ndata(ds\$)
                zij = datayvalue(ds\$,i)
                cij\$ = \"\"
                $ifpart
                $boxpart
            next i
        end sub
        """
    return nothing
end
