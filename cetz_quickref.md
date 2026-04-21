# CeTZ Quick Reference For DrawFeyn

This note only keeps the CeTZ pieces that are directly useful for `DrawFeyn`.

## Import and canvas

```typst
#import "@preview/cetz:0.5.0": canvas, draw
#import draw: bezier, circle, content, line, mark

#canvas(length: 1cm, {
  line((0, 0), (1, 0))
})
```

- `canvas(length: ...)` sets the physical scale of coordinates.
- Coordinates are plain Typst arrays like `(x, y)`.

## Core draw functions used here

- `line(a, b, stroke: ...)`: straight propagators or helper strokes.
- `bezier(a, b, control, stroke: ...)`: photon waves and gluon coils.
- `circle(center, radius: ..., fill: ..., stroke: ...)`: vertices, bubbles, and helper markers.
- `content(position, body)`: labels such as `$p$`, `$gamma$`, or particle names.
- `mark(a, b, symbol: "stealth", ...)`: arrowheads on fermion lines.

## Geometry patterns that help this package

- Sample a curve into many points, then draw short `line(...)` segments for arcs.
- Use a midpoint plus a rotated tangent/normal vector to place labels.
- Alternate the sign of the normal offset to build wave and coil patterns.

## Useful transforms

- `draw.translate((x, y))` or `draw.translate(x: ..., y: ...)`: shift the coordinate system for subsequent drawing commands.
- `draw.rotate(angle, origin: ...)`: reuse a small drawing group at another angle.
- `draw.scale(x: ..., y: ...)`: stretch a circle into an ellipse-like helper shape.

## Useful CeTZ feature not yet used directly

- `decorations.wave(...)` is a strong candidate for future photon propagators, because it decorates a base path with a wave pattern instead of manually chaining Bézier segments.

## Docs worth reopening

- Getting started: https://cetz-package.github.io/docs/getting-started/
- Draw functions: https://cetz-package.github.io/docs/api/draw-functions/
- Decorations: https://cetz-package.github.io/docs/api/decorations/
