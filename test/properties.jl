@testset "▶ set_prop/properties         " begin
  f = Figure()
  set(f, alpha=true)
  @test f.transparency

  # checkers
  @test G.id(5, :a) == 5
  @test G.id("hello", :a) == "hello"
  @test G.fl(5, :a) == 5.0
  @test G.fl((5,2),:a) == (5.0,2.0)
  @test G.not(true, :a) == false
  @test G.lc("blAh", :a) == "blah"
  @test G.lc(["bLASD", "BLad"], :a) == ["blasd", "blad"]
  @test G.col(colorant"blue", :a) == colorant"blue"

  @test G.opcol("blue", :a) == colorant"blue"
  @test G.opcol("none", :a) === nothing
  set(f, alpha=false)
  a = 0
  @test_logs (:warn, "Transparent background is only supported when the figure " *
                     "has its transparency property set to 'true'.") (a=G.opcol("none", :a))
  @test a == colorant"white"

  set(f, alpha=true)
  @test G.alpha(0.2, :a) == 0.2
  set(f, alpha=false)
  a = 0
  @test_logs (:warn, "Transparent colors are only supported when the figure " *
                     "has its transparency property set to 'true'. Ignoring α.") (a=G.alpha(.2, :a))
  @test a == 1.0

  text("blah", (0.5,0.5), font="tt")
  @test gca().objects[1].textstyle.font == "tt"
end
