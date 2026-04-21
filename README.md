# DrawFeyn

`DrawFeyn` is a Typst package skeleton for drawing Feynman diagrams with `cetz`.

## Structure

- `lib.typ` exposes the package interface.
- `src/vectors.typ` contains 2D vector helpers.
- `src/geometry.typ` contains curve sampling and label placement helpers.
- `src/render.typ` contains the drawing primitives for fermions, photons, gluons, scalars, loops, helper shapes, and old-demo compatibility wrappers.
- `examples/basic.typ` gives a quick introduction.
- `examples/showcase.typ` contains a wider set of diagrams.
- `cetz_quickref.md` is a short CeTZ note focused on features used here.
- `.vscode/tasks.json` adds build tasks for VS Code.

## Usage

Import the library from a Typst file:

```typst
#import "../lib.typ": *

#diagram(length: 1cm, {
  fermion((0, 0), (1, 1), re: -1, label: $p$)
  photon((1, 1), (3, 1), vertex_show: true, label: $gamma$)
  fermion((3, 1), (4, 0), label: $k$)

  // Move the drawing coordinates by (1, 0).
  // After this, vertex((0, 0)) appears at canvas position (1, 0).
  translation((1, 0))
  vertex((0, 0))
})
```

The refactor keeps the newer names above and also preserves the old demo-style entry points such as `Dot`, `ph`, `ppa_arc`, `premark`, `waveline`, `four_gluon_s`, and `four_gluon_t`.

`gluon` supports `form: 2` (or `form: "spiral"`) for a centered loop propagator ported from `src/gluonplot.wl`. It uses the same phase-shifted parameterization so the endpoints stay on the propagator centerline, `turns` controls the number of loops, and `amplitude` is the loop radius in diagram units.

`translation(...)` is a convenience wrapper around CeTZ `draw.translate(...)`. Use it inside `diagram(...)` to shift the coordinate system for subsequent drawing commands; for example `translation((1, 0))` makes later coordinates appear one unit to the right.

## Build

From VS Code, run the `Build DrawFeyn Showcase` task.

From a terminal:

```powershell
typst compile examples/showcase.typ examples/showcase.pdf
typst compile examples/basic.typ examples/basic.pdf
```
