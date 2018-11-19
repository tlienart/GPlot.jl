#

* (**ongoing**) Wrapper for the [Graphics Layout Engine](http://glx.sourceforge.net/index.html)
* (**upcoming**) Allow both GLE and Gnuplot as backend. Different than Gaston as no attempt at being interactive.

## Notes

* everything in cm, for font, conversion is `10pt = 0.352778cm` could do `const pt = 0.352778` but it's potentially clashing name, maybe better to have a function that takes point and does the conversion itself.

## Todo

* `lstyle`
    - 9229 should also work (see p21), `split_digits(a::Int)=parse.(Int, [e for e ∈ string(a)])`
