include("src/exgen/genall.jl")

cdir = @__DIR__

fname = "quickstart.md"

open(joinpath(cdir, "src/man/$fname"), "w") do outf
    inf = read(joinpath(cdir, "src/man/_$fname"), String)
    matches = eachmatch(r"@@[A-Z]+:(.*\b)", inf)

    if isempty(matches)
        write(outf, inf)
    else
        head = 1
        for m ∈ matches
            # PRE = write everything up to HEAD *not included*
            write(outf, inf[head:prevind(inf, m.offset)])
            # MOVE THE HEAD TO AFTER THE EXPRESSION
            head = m.offset + length(m.match)

            # WHAT KIND OF BLOCK IS IT?
            if startswith(m.match, "@@CODE")
                # FIND THE FILE
                name = m.captures[1]
                incf = read(joinpath(cdir, "src/exgen/$name.jl"), String)
                # WRITE IT APPROPRIATELY GUARDED
                write(outf, "\n```julia\n$incf```\n")
            elseif startswith(m.match, "@@IMG")
                # FIND THE IMAGE (FOR NOW ASSUMED SVG FORMAT)
                name = m.captures[1]
                # WRITE IT APPROPRIATELY GUARDED
                write(outf, "\n![](../exgen/out/$name.svg)\n")
            end
        end
        write(outf, inf[head:end])
    end
end

include("make.jl")
