using GPlot, Colors

continuous_preview(false)

begin # GENERATION OF FIGURES
    function gen(s::String; format="svg")
        include(joinpath(@__DIR__, "src", "exgen", s*".jl"))
        savefig(gcf(), s; format=format, path=joinpath(@__DIR__, "src", "exgen", "out"), res=200)
    end

    f = Figure(size=(10,8))

    # quickstart
    gen("qs_ex1")
    gen("qs_ex2")

    # line-scatter
    gen("ls_ex1")
    gen("ls_ex2")
    gen("ls_ex3")
    gen("ls_ex4")
    gen("ls_ex5")
    gen("ls_ex5b")
    gen("ls_ex6")
    gen("ls_ex7")
    cla(); gen("ls_ex8")
    gen("ls_ex9")
    gen("ls_ex10")
    gen("ls_ex11")

    # hist-bar
    gen("hb_ex1")
    gen("hb_ex2")
    gen("hb_ex3")
    gen("hb_ex4")
    gen("hb_ex5")
    gen("hb_ex6")
    gen("hb_ex7")
    gen("hb_ex8")
end

begin
    cdir = @__DIR__

    for fname = ["quickstart.md",
                 "line-scatter.md",
                 "hist-bar.md"]
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
                    if startswith(m.match, "@@CODEIMG")
                        # FIND THE FILE
                        name = m.captures[1]
                        incf = read(joinpath(cdir, "src/exgen/$name.jl"), String)
                        # WRITE IT APPROPRIATELY GUARDED
                        write(outf, "\n```julia\n$incf```\n")
                        # WRITE THE IMG APPROPRIATELY GUARDED
                        write(outf, "\n![](../exgen/out/$name.svg)\n")
                    elseif startswith(m.match, "@@CODE")
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
    end
    include("make.jl")
end # RUN PREMAKE
