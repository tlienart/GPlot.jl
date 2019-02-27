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


function add_sub_boxplot!(f::Figure, b::BoxplotStyle)
    if str(b) ∉ keys(f.subroutines)
        # This subroutine is modified from the complimentary `graphutil.gle`
        # shipped as extra scripts in GLE.
        f.subroutines[str(b)] = """
        sub $(str(b)) x wlow q25 q50 q75 whigh
            local bwidth = 0.4  ! central box width
            local msize = 1.5   ! marker size
            set cap round       ! open lines have rounded ends

            ! lower whisker
            amove xg(x)-bwidth/2 yg(wlow)
            aline xg(x)+bwidth/2 yg(wlow)
            ! vertical connection to box
            amove xg(x) yg(wlow)
            aline xg(x) yg(q25)
            ! box
            amove xg(x)-bwidth/2 yg(q25)
            box bwidth yg(q75)-yg(q25)
            ! horizontal line at median
            amove xg(x)-bwidth/2 yg(q50)
            aline xg(x)+bwidth/2 yg(q50)
            ! vertical connection from box
            amove xg(x) yg(q75)
            aline xg(x) yg(whigh)
            ! upper whisker
            amove xg(x)-bwidth/2 yg(whigh)
            aline xg(x)+bwidth/2 yg(whigh)
        end sub
        """
    end
    return nothing
end
