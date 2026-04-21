#import "../lib.typ": *

#set page(margin: 1.2cm, fill: white)

= DrawFeyn Showcase

This file collects the first-version DrawFeyn examples.

== Common diagrams


#align(center)[
  #diagram(length: 1cm, {
    fermion((0, 0), (1.2, 1.2), re: -1, label: $p$)
    photon((1.2, 1.2), (3.4, 1.2), vertex_show: true, label: $gamma$)
    fermion( (4.5, 0),(3.4, 1.2), label: $k$)
    fermion((1.2, 1.2), (0, 2.4), re: -1, label: $p'$)
    fermion((3.4, 1.2), (4.5, 2.4), label: $k'$)
    put_label((-0.35, 0), $e^-$)
    put_label((-0.35, 2.4), $e^+$)
    put_label((4.85, 0), $mu^+$)
    put_label((4.85, 2.4), $mu^-$)
  })
]

#align(center)[
  #diagram(length: 1cm, {
    let common_offset = 0.35
    let fermion = fermion.with(label_offset: common_offset)
    let photon = photon.with(label_offset: common_offset)
    let scalar = scalar.with(label_offset: common_offset)
    let gluon = gluon.with(label_offset: common_offset)
    fermion((0, 0), (1.1, 1.0), re: -1, label: $p_1$)
    photon((1.1, 1.0), (1.9, 1.0), segments: 6)
    bubble((2.4, 1.0), radius:0.5,body: [$J\/psi$])
    photon((2.9, 1.0), (3.7, 1.0), segments: 6)
    fermion((4.8, 0),(3.7, 1.0), label: $k_2$)
    fermion((1.1, 1.0), (0, 2.0), re: -1, label: $p_2$)
    fermion((3.7, 1.0), (4.8, 2.0), label: $k_1$)
    put_label((-0.35, 0), $e^-$)
    put_label((-0.35, 2.0), $e^+$)
    put_label((5.05, 0), $tau^+$)
    put_label((5.05, 2.0), $tau^-$)
  })
]

#v(1.4em)

#align(center)[
  #diagram(length: 3cm, {
    fermion((0.2, 0), (1.0, 0))
    scalar((2.0, 0), (1.0, 0), angle: 180deg, style: "dashed", segments: 15)
    fermion((1.0, 0), (1.45, 0))
    fermion((1.45, 0), (2.0, 0))
    photon((1.45, 0), (1.45, -0.7),amplitude: .05, segments: 16)
    fermion((2.0, 0), (2.7, 0))
    put_label((1.15, -0.42), $q^2 < 0$)
    put_label((1.45, 0.34), $a$)
    put_label((0.2, 0.22), $e^-$)
    put_label((2.7, 0.22), $e^-$)
  })
]

#align(center)[
  #diagram(length:1cm,{
    photon((-2,1),(0,0))
    photon((-2,-3),(0,-2))
    photon((0,0),(0,-2))
    scalar((0,0),(2,1))
    scalar((0,-2),(2,-3))
    draw.translate(x:6,y:0)
    photon((-2,1),(0,0))
    photon((-2,-3),(0,-2))
    photon((0,0),(0,-2))
    scalar((0,0),(2,-3),segments:12)
    scalar((0,-2),(2,1),segments:12)
  })
]

== Fermion Loops

#align(center)[
  #diagram(length: 1cm, {
    fermion((0, 0), (1.5, 0.9), angle: 0deg, re: 1, label: $p$,label_offset: .3)
    fermion((1.5, 0.9), (3.0, 0), angle: 0deg, re: -1, label: $p'$,label_offset: -.4)
    photon((1.5, 0.9), (1.5, 2.8), angle: 0deg, re: 1, label: $gamma$,amplitude: .2,label_offset: .4)
    scalar((-1.0,3.3),(.9,3.3),segments: 8,)
    scalar((2.1,3.3),(4.0,3.3))
    // scalar((4, 2.8), (6.0, 2.8), angle: 180deg, re: -1, style: "dashed", label: $phi$)
    fermion_loop((1.5, 2.8), (1.5, 4.0))
  })
]

#v(1.2em)



#v(1.2em)


== Gluon

#grid(columns: (1fr,1fr,1fr),
align(center)[
  #diagram(length: 1cm, {
    gluon((0.6, 1.3), (2.4, 1.3), turns: 7, form: 2,radius:.1,re:-1)
    gluon((2.4, 1.3), (3.3, 2.2), form: 2, turns: 7,radius:.08)
    gluon((2.4, 1.3), (3.1, 0.4), form: 2, turns: 7,radius:.08)
  })
],
align(center)[
  #diagram(length: 1cm, {
    let s = four_gluon_s((1.4, 1.2), 1.1)
    s.at(0)
    for index in range(s.at(1).len()) {
      put_label(
        add(s.at(1).at(index), scale(unit(sub(s.at(1).at(index), (1.4, 1.2))), 0.24)),
        [$#(index + 1)$],
      )
    }
  })
],
align(center)[
  #diagram(length: 1cm, {
    let t = four_gluon_t((1.4, 1.2), 1.1)
    t.at(0)
    for index in range(t.at(1).len()) {
      put_label(
        add(t.at(1).at(index), scale(unit(sub(t.at(1).at(index), (1.4, 1.2))), 0.24)),
        [$#(index + 1)$],
      )
    }
  })
]
)
