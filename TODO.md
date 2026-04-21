# Lists of TODO

I want to make a package for drawing Feynman diagram quickly based on typst.cetz.

## Basic rules
- Following each subsection will be followed by "(status: finished/continue)". If the part is "finished" just skip it.
- The demo "../cetz_feyndraw.typ" is an old version demo, you don't need use the same method, as the same functions is the only requirement.
- Like a project, put the vector calculation, plot realization and example in different files.

- The skill "typst-writer" should always be used.

## The package (status:finished)

This project shall be based on "https://github.com/cetz-package/cetz" with the newest version.


```
#import "@preview/cetz:0.5.0"
```
The mannul can be find in the "https://cetz-package.github.io/docs/".
After you read it, **write a short doc/mannul** in local named "cetz_" for those may helpful for this project.(Don't include that won't used in this project.)
(*for example, the method wave(...) can be used to plot photon propagator*)


## Gluon propagator(status:continue)

Rewrite the form 2 gluon propator in "DrawnFeyn/src/render".
1. The core section contains approximately 4–5 (configurable) rounded "U" or inverted "U" shaped loops.
2. Delivered as a standardized vector graphic.
3. The start point, end point, and number of loops are controlled via parameters.
4. Ensures the endpoints always remain aligned to the vertical center of the graphic.
5. the start point and end point are always outsides (compare with hole)