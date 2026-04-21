# DrawFeyn

`DrawFeyn` is a small Typst/CeTZ helper package for drawing Feynman diagrams with coordinate-based primitives. It provides reusable propagators, labels, vertices, simple helper shapes, vector utilities, and compatibility wrappers for an older demo-style API.

The implementation is based on CeTZ:

```typst
#import "@preview/cetz:0.5.0": canvas, draw
```

## Project Layout

- `lib.typ` re-exports the public package modules.
- `src/vectors.typ` defines 2D vector helpers such as `add`, `sub`, `scale`, `unit`, `rotate`, `polar`, and compatibility aliases.
- `src/geometry.typ` provides line/arc sampling, arc centers, arc splitting, and label placement helpers.
- `src/render.typ` contains the diagram canvas wrapper and drawing primitives for propagators, vertices, loops, bubbles, axes, and four-gluon helper diagrams.
- `examples/showcase.typ` demonstrates the current package API.
- `cetz_quickref.md` records the CeTZ calls and transform patterns used by this package.

## Quick Start

Import the local package from a Typst file:

```typst
#import "../lib.typ": *

#diagram(length: 1cm, {
  fermion((0, 0), (1.2, 1.2), re: -1, label: $p$)
  photon((1.2, 1.2), (3.4, 1.2), vertex_show: true, label: $gamma$)
  fermion((4.5, 0), (3.4, 1.2), label: $k$)
})
```

`diagram(length: ..., { ... })` creates a CeTZ canvas and sets the physical scale for drawing coordinates.

## Core API

### Propagators

- `fermion(a, b, ...)` draws a line or arc with a fermion arrow.
- `photon(a, b, ...)` draws a wavy photon line.
- `scalar(a, b, ...)` draws a dashed scalar line by default, or a plain line with `style: "plain"` / `form: "plain"`.
- `gluon(a, b, ...)` draws a gluon propagator. `form: 2` or `form: "spiral"` uses the centered loop-style propagator; other forms use the alternating coil style.
- `fermion_loop(a, b, ...)` draws a closed two-arc fermion loop with arrows.

Most propagators accept common options such as:

- `angle` for curved arcs; use `calc.inf` for straight lines.
- `re` to choose the curve side/orientation.
- `label` or legacy `m` to place a label.
- `label_offset` to tune label distance.
- `vertex_show: true` to show endpoint vertices.
- `stroke` for line color/thickness.

### Vertices, Labels, and Helpers

- `vertex(position, ...)` / `Dot(position, ...)` draw filled vertices.
- `put_label(position, body)` places Typst content at a coordinate.
- `bubble(position, ...)`, `oval(...)`, and `ox(...)` draw simple annotation shapes.
- `axis(...)` draws coordinate axes with optional ticks.
- `premark(...)` places an arrow marker.
- `ppa_arc(...)`, `draw_curve(...)`, and `draw_polyline(...)` expose lower-level curve helpers.
- `four_gluon_s(...)` and `four_gluon_t(...)` build reusable four-gluon vertex layouts and return both drawing content and external leg coordinates.

### Transforms

The package exposes CeTZ's `draw` namespace through `render.typ`, so examples can use transforms directly:

```typst
#diagram(length: 1cm, {
  photon((-2, 1), (0, 0))
  scalar((0, 0), (2, 1))

  draw.translate(x: 6, y: 0)
  photon((-2, 1), (0, 0))
  scalar((0, 0), (2, -3))
})
```

`Rot_group(body, angle, origin: ...)` is also available as a small wrapper around `draw.rotate`.

## Gluon Notes

`gluon` currently supports two drawing modes:

- `form: 2` / `form: "spiral"`: a centered loop propagator adapted from `src/gluonplot.wl`. The endpoints stay on the propagator centerline, `turns` or `node` controls the number of loops, and `radius` controls the loop radius.
- Other forms: an alternating Bézier coil built from sampled centerline segments.

Useful parameters:

```typst
gluon((0, 0), (3, 0), form: 2, turns: 10, radius: .1, re: -1)
```

## Compatibility Names

Several older demo-style names are still available, including:

- `Dot`
- `ph`
- `ppa_arc`
- `premark`
- `waveline`
- `waveline_group`
- `no_match_cir`
- `four_gluon_s`
- `four_gluon_t`

Vector aliases such as `minu`, `scal`, `norm`, `inner_product`, `sgn`, `rot_vec_2dim`, `polar_crd`, `arc_angel2crd`, and `crd2angel` are also preserved.

## Build Examples

Compile the showcase from the package root:

```powershell
typst compile examples/showcase.typ examples/showcase.pdf
```

Compile the compact SVG-maker example:

```powershell
typst compile examples/svgmaker.typ examples/svgmaker.pdf
```

In VS Code, the `Build DrawFeyn Showcase` task compiles `examples/showcase.typ`.

## Development Notes

- The public interface is currently local-first: import `lib.typ` from this repository.
- The current examples are `showcase.typ` and `svgmaker.typ`; the old `basic.typ` example is no longer present.
- `src/gluonplot.wl` and `src/gluonplot_preview.png` document the Mathematica prototype for the centered gluon shape.
