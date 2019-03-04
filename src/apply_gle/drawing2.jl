####
#### Apply Boxplot
####

function apply_drawing!(g::GLE, bp::Boxplot,
                        el_counter::Int, origin::T2F, figid::String)

    # 1. add boxplot subroutines (verticald and horizontal) if not there already
    subname = ifelse(bp.horiz, "bp_horiz", "bp_vert")
    f = Figure(figid; _noreset=true)
    if subname ∉ keys(f.subroutines)
        f.subroutines[subname] = GLE_DRAW_SUB[subname]
    end

    for k ∈ 1:bp.nobj
        # draw the boxplots one by one

        # 1. retrieve the statistics
        wlow, q25, q50, q75, whigh, mean = bp.stats[k, :]

        # 2. call the subroutine
        s = bp.boxstyles[k]
        "\n\tdraw $(ifelse(bp.horiz, "bp_horiz", "bp_vert"))" |> g
        "$k $wlow $q25 $q50 $q75 $whigh $mean"                          |> g
        # box styling
        sbl = s.blstyle
        "$(s.bwidth) $(s.wwidth) $(sbl.lstyle) $(sbl.lwidth) \"$(col2str(sbl.color))\"" |> g
        # median line
        sml = s.mlstyle
        "$(sml.lstyle) $(sml.lwidth) \"$(col2str(sml.color))\"" |> g
        # mean marker NOTE: the marker size drawn by itself and in a plot are not scaled the same
        # way, to make them scale the same way there is the division by textstyle.hei.
        sm = s.mmstyle
        "$(Int(s.mshow)) $(sm.marker) $(sm.msize/f.textstyle.hei) \"$(col2str(sm.color))\"" |> g

        el_counter += 1
    end
    return el_counter
end

####
#### Apply Heatmap
####

function apply_drawing!(g::GLE, hm::Heatmap,
                        el_counter::Int, origin::T2F, figid::String)

    # 1. apply the subroutine with a hash depending on origin cum figid
    hashid = hash((origin, figid))
    add_sub_heatmap!(Figure(figid; _noreset=true), hm, hashid)

    # 2. write the zfile
    faux = auxpath(hash(hm.data), origin, figid)
    isfile(faux) || csv_writer(faux, hm.transpose ? hm.data' : hm.data, false)

    nrows, ncols = size(hm.data)
    bw, bh = inv.((ncols, nrows))
    hm.transpose && (tmp = bw; bw = bh; bh = bw)

    nct = ifelse(hm.transpose, nrows, ncols)

    # 3. load data
    vs = prod("d$j=c0,c$j " for j ∈ 1:nct)
    "\n\tdata \"$faux\" $vs" |> g

    # 4. go over all the columns and draw the boxes (scales linearly with # cols)
    for j ∈ 1:nct
        "\n\tdraw hm_$hashid $j d$j $bw $bh" |> g
    end
    return el_counter + 1
end
