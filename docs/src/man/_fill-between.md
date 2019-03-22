# Fill between lines

@@IMG:fb_demo

## Syntax

The relevant commands here are

- `fill_between` and `fill_between!`,

and the syntax is:

```julia
command(x, y1, y2; options...)
```

where

* `x` must be a vector of values or a range of values,
* `y1` and `y2` can either be a real value (horizontal line) or a vector of values of length matching `x`.

For instance:

@@CODEIMG:fb_ex1

## Styling options

* **from/to** [`from`, `min`, `xmin` // `to`, `max`, `xmax`]: takes a number indicating one or both vertical limits for the fill.

@@CODEIMG:fb_ex2

* **fill colour** [`col`, `color`, `fill`]: takes a colour to use for the filling (see examples above).

* **alpha** [`alpha`]: when considering a transparent-capable output format, this takes a number between 0 and 1 indicating the level of transparency (towards 0 is more transparent, towards 1 more opaque).

@@CODEIMG:fb_ex3
