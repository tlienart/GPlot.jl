# GPlot.jl - Documentation

```@meta
#=
Todo:
- work out how to have syntax highlighting

- Appendix/fonts
  - link to tug.dk font catalogue, suggest the ones that work with pdflatex

- preview mode: if in a wrapped scope, the continuous preview will
not happen, need to explicitly call preview for instance
@elapsed text!(...) will not display unless preview is called explicitly

- when adding text, there's no overwrite (ambiguous) so if it fails you'll need to use `cla()` liberally. same if you want to change from notex to latex mode use cla or clf and then set(gcf, tex=true) and then go again. Can use `clo!` to remove objects leaving rest
unchanged

- API

-- plotting stuff with ! = append
-- everything else doesn't have ! bc confusing

- Latex

-- t"x^{\star}" will work but t"\sqrt" won't unless you use TeX in the figure. (need to show examples for this)
-- \it , \bf

=#
```
