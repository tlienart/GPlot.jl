####
#### Subroutines for GLE
####

"""
    add_sub_marker!(f, m)

Internal function to add an appropriate subroutine to the GLE script to deal with markers that
must have a different color than the line they are associated with. For instance if you want a
blue line with red markers, you need to define a specfici subroutine for red-markers otherwise
both line and markers are going to be of the same color.
Note: these subroutines all start with the name `marker_....` (see [`str`](@ref)).
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


function add_sub_boxplot!(f::Figure, el_counter::Int, stats::NamedTuple, b::BoxplotStyle)
    if str(b) ∉ keys(f.subroutines)
        # This subroutine is modified from the complimentary `graphutil.gle`
        # shipped as extra scripts in GLE.
        f.subroutines[str(b)] = """
        sub $(str(b)) bwidth msize
            default bwidth 0.4  ! central box width
            default msize 1.5   ! marker size
            set cap round       ! open lines have rounded ends

            local x = $(el_counter)

            local meanv = $(stats.mean)
            local medv = $(stats.median)
            local minv = $(stats.min)
            local maxv = $(stats.max)
            local w1 = $(stats.low)     ! lower whisker
            local w2 = $(stats.high)    ! higher whisker

            amove xg(x)-bwidth/2 yg(minv)
            aline xg(x)+bwidth/2 yg(minv)
            amove xg(x) yg(minv)
            aline xg(x) yg(w1)
            amove xg(x)-bwidth/2 yg(w1)
            box bwidth yg(w2)-yg(w1)
            amove xg(x)-bwidth/2 yg(medv)
            aline xg(x)+bwidth/2 yg(medv)
            amove xg(x) yg(w2)
            aline xg(x) yg(maxv)
            amove xg(x)-bwidth/2 yg(maxv)
            aline xg(x)+bwidth/2 yg(maxv)
            amove xg(x) yg(meanv)
            marker fdiamond msize*bwidth

        end sub
        """
    end
    return nothing
end
