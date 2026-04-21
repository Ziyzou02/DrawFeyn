#import "../lib.typ": *

#set page(margin: 1.2cm, fill: white)

= DrawFeyn Basic Examples

#align(center)[
  #diagram(length: 1cm, {
    fermion((0, 0), (1.2, 1.2), re: -1, label: $p$)
    photon((1.2, 1.2), (3.4, 1.2), vertex_show: true, label: $gamma$)
    fermion((3.4, 1.2), (4.5, 0), label: $k$)
    fermion((1.2, 1.2), (0, 2.4), re: -1, label: $p'$)
    fermion((3.4, 1.2), (4.5, 2.4), label: $k'$)
    put_label((-0.35, 0), $e^-$)
    put_label((-0.35, 2.4), $e^+$)
    put_label((4.85, 0), $mu^+$)
    put_label((4.85, 2.4), $mu^-$)
  })
]

#v(1.2em)

#align(center)[
  #diagram(length: 1cm, {
    gluon((1.6, 0.2), (1.6, 2.4), turns: 10, label: $g$)
    gluon((0.2, -0.5), (1.6, 0.2), turns: 8,form:2,amplitude: .1,radius: .08)
    gluon((3.0, -0.5), (1.6, 0.2), turns: 8)
    vertex((1.6, 0.2))
  })
]

#v(1.2em)

#align(center)[
  #diagram(length: 1cm, {
    scalar((0, 0), (2.2, 0), angle: 180deg, style: "dashed", segments: 8, label: $k$)
    fermion((2.2, 3.2), (3.3, 3.2))
    fermion_loop((2.2, 3.2), (3.3, 3.2))
    gluon((3.3, 0), (3.3, 2.3), angle: 120deg, re: -1, turns: 10)
    vertex((0, 0))
    put_label((0.05, 0.18), $O$)
    vertex((3.3, 0))
    vertex((3.3, 2.3))
  })
]
