# Figure, Axes and Axis

## Figure

- transparency should not be used unless you really need to as it restricts the device you can use to only PNG as well as the fonts you can use. Effectively transparency should only be used for fillbetween and possibly overlapping histograms.

## Axes and Axis

TBD:
- note that x2axis/y2axis revert to xaxis/yaxis (GLE restriction)
- cannot have xaxis off and x2axis on, same for y
- if xticks happens after grid it will disable, should use xticks! if want to change position
- ticks angle are in degrees, rotation is clockwise (e.g. 45)
