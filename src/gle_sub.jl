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
    str(m) ∈ keys(f.subroutines) && return nothing
    f.subroutines[str(m)] = """
        sub _$(str(m)) size mdata
        	gsave
            set color $(col2str(m.color))
            marker $(m.marker) size
        	grestore
        end sub
        define marker $(str(m)) _$(str(m))
        """
    return nothing
end

const GLE_DRAW_SUB = Dict{String,String}()

###############################################################
####
#### Boxplot subroutine
####
###############################################################

const boxplot_box_lstyle = """set lstyle blstyle lwidth blwidth color blcolor\$"""
const boxplot_med_lstyle = """set lstyle medlstyle lwidth medlwidth color medcolor\$"""
const boxplot_mean_mstyle = """
    gsave
    \tset color mmcol\$
    \tmarker mmarker\$ mmsize
    \tgrestore"""
const boxplot_core_vertical = """
    ! -----------------------------------------
    \t! SET LINE STYLE THEN DRAW BOX AND WHISKERS
    \t! -----------------------------------------
    \tgsave
    \tset cap round
    \t$boxplot_box_lstyle
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
    \t! ------------------------------------
    \t! SET LINE STYLE THEN DRAW MEDIAN LINE
    \t! ------------------------------------
    \tgsave
    \t$boxplot_med_lstyle
    \tamove xg(p-bwidth/2) yg(q50)
    \taline xg(p+bwidth/2) yg(q50)
    \tgrestore
    \t! --------------------------------------
    \t! SET MARKER STYLE THEN DRAW MEAN MARKER
    \t! --------------------------------------
    \tif (mshow > 0) then
    \t    amove xg(p) yg(mean)
    \t$boxplot_mean_mstyle
    \tend if"""
const boxplot_core_horizontal = """
    ! -----------------------------------------
    \t! SET LINE STYLE THEN DRAW BOX AND WHISKERS
    \t! -----------------------------------------
    \tgsave
    \tset cap round
    \t$boxplot_box_lstyle
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
    \t! ------------------------------------
    \t! SET LINE STYLE THEN DRAW MEDIAN LINE
    \t! ------------------------------------
    \tgsave
    \t$boxplot_med_lstyle
    \tamove xg(q50) yg(p-bwidth/2)
    \taline xg(q50) yg(p+bwidth/2)
    \tgrestore
    \t! --------------------------------------
    \t! SET MARKER STYLE THEN DRAW MEAN MARKER
    \t! --------------------------------------
    \tif (mshow > 0) then
    \t    amove xg(mean) yg(p)
    \t    $boxplot_mean_mstyle
    \tend if"""
const boxplot_args = ("p wlow q25 q50 q75 whigh mean ", # NOTE don't forget space at the end
                      "bwidth wwidth blstyle blwidth blcolor\$ ",
                      "medlstyle medlwidth medcolor\$ ",
                      "mshow mmarker\$ mmsize mmcol\$ ")

GLE_DRAW_SUB["bp_vert"] = """
    sub bp_vert $(prod(boxplot_args))
        $boxplot_core_vertical
    end sub
    """

GLE_DRAW_SUB["bp_horiz"] = """
    sub boxplot_horiz $(prod(boxplot_args))
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
        if zij <= 1 then
        \t\t    cij\$ = \"$(col2str(hm.cmap[1]))\""""
    for k ∈ 2:length(hm.cmap)-1
        ifpart *= """
            \n\t\telse if zij <= $k then
            cij\$ = \"$(col2str(hm.cmap[k]))\""""
    end
    ifpart *= """
        \n\t\telse
            cij\$ = \"$(col2str(hm.cmiss))\"
        end if"""

    boxpart = ifelse(hm.transpose, """
        amove xg((i-1)*bh) yg(1-j*bw)
        \t\tbox xg(bh)-xg(0) yg(bw)-yg(0) nobox fill cij\$""", """
        amove xg((j-1)*bw) yg(1-i*bh)
        \t\tbox xg(bw)-xg(0) yg(bh)-yg(0) nobox fill cij\$""")

    f.subroutines["hm_$hashid"] = """
        sub hm_$hashid j ds\$ bw bh
            local zij = 0
            local cij = \"\"
            for i = 1 to ndata(ds\$)
                zij = datayvalue(ds\$,i)
                $ifpart
                $boxpart
            next i
        end sub
        """
    return nothing
end


###############################################################
####
#### Palette a vector of colors
####
###############################################################

function add_sub_palette!(f::Figure, vc::Vector{<:Color})
    nc   = length(vc)-1
    incr = 1/(length(vc)-1)
    bot = vc[1]
    top = vc[2]
    core = """
        local r = 0
        \tlocal g = 0
        \tlocal b = 0
        \tif (z <= $incr) then
        \t    r = $(round3d(bot.r))*(1-z*$nc)+$(round3d(top.r))*z*$nc
        \t    g = $(round3d(bot.g))*(1-z*$nc)+$(round3d(top.g))*z*$nc
        \t    b = $(round3d(bot.b))*(1-z*$nc)+$(round3d(top.b))*z*$nc
        """
    for i ∈ 2:length(vc)-1
        bot = vc[i] # bottom color
        top = vc[i+1]   # top color
        core *= """
            \telse if ($(incr*(i-1)) < z) and (z <= $(incr*i)) then
            \t    r = $(round3d(bot.r))*(1-(z-$(incr*(i-1)))*$nc)+$(round3d(top.r))*(z-$(incr*(i-1)))*$nc
            \t    g = $(round3d(bot.g))*(1-(z-$(incr*(i-1)))*$nc)+$(round3d(top.g))*(z-$(incr*(i-1)))*$nc
            \t    b = $(round3d(bot.b))*(1-(z-$(incr*(i-1)))*$nc)+$(round3d(top.b))*(z-$(incr*(i-1)))*$nc
            """
    end
    core *= """\tend if"""

    pname = "cmap_$(hash(vc))"
    pname ∈ keys(f.subroutines) && return nothing
    f.subroutines[pname] = """
        sub $pname z
            $core
            return rgb(r,g,b)
        end sub
        """
    return nothing
end


###############################################################
####
#### Plot a 3D line
####
###############################################################

function add_sub_plot3!(f::Figure)
    "plot3" ∈ keys(f.subroutines) && return nothing
    xs = "(xo-xmin)/xspan"
    ys = "(yo-ymin)/yspan"
    f.subroutines["plot3"] = """
        sub plot3 data\$ xmin xspan ymin yspan showline showmarker marker\$ mscale
            xo = 0
            yo = 0
            zo = 0
            io = 0
            fopen data\$ file read
            until feof(file)
                fread file x y z
                xo = x
                yo = y
                zo = z
                io = io+1
                if (io<=1) then
                    amove xg3d($xs,$ys,zo) yg3d($xs,$ys,zo)
                    if (showmarker > 0) then
                        marker marker\$ mscale
                    end if
                else
                    if (showline >= 1) then
                        aline xg3d($xs,$ys,zo) yg3d($xs,$ys,zo)
                    else
                        amove xg3d($xs,$ys,zo) yg3d($xs,$ys,zo)
                    end if
                    if (showmarker > 0) then
                        marker marker\$ mscale
                    end if
                end if
            next
            fclose file
        end sub
        """
    return nothing
end
