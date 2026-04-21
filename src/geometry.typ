#import "vectors.typ": add, sub, scale, magnitude, unit, rotate, midpoint, polar, angle_from

#let line_points(a, b, samples: 2) = {
  let count = if samples < 2 { 2 } else { samples }
  let points = ()
  for i in range(count) {
    let t = i / (count - 1)
    points = points + (add(scale(a, 1 - t), scale(b, t)),)
  }
  points
}

#let arc_center(a, b, angle, re: 1) = {
  if angle == calc.inf or calc.abs(angle) == 0deg {
    none
  } else {
    let chord = sub(b, a)
    let half = magnitude(chord) / 2
    let theta = calc.abs(angle)
    let normal = unit(rotate(chord, if re >= 0 { 90deg } else { -90deg }))
    let offset = half / calc.tan(theta / 2)
    add(midpoint(a, b), scale(normal, offset))
  }
}

#let arc_points(a, b, angle: calc.inf, re: 1, samples: 16) = {
  let count = if samples < 2 { 2 } else { samples }
  if angle == calc.inf or calc.abs(angle) == 0deg {
    return line_points(a, b, samples: count)
  }

  let center = arc_center(a, b, angle, re: re)
  if center == none {
    return line_points(a, b, samples: count)
  }

  let radius = magnitude(sub(a, center))
  let start_angle = angle_from(center, a)
  let sweep = if re >= 0 { calc.abs(angle) } else { -calc.abs(angle) }
  let points = ()

  for i in range(count) {
    let t = i / (count - 1)
    let current = start_angle + sweep * t
    points = points + (add(center, polar(radius, current)),)
  }

  points
}

#let label_position(a, b, angle: calc.inf, re: 1, offset: 0.18) = {
  if angle == calc.inf or calc.abs(angle) == 0deg {
    let normal = unit(rotate(sub(b, a), 90deg))
    add(midpoint(a, b), scale(normal, offset * re))
  } else {
    let points = arc_points(a, b, angle: angle, re: re, samples: 21)
    let center = arc_center(a, b, angle, re: re)
    let middle = points.at(calc.floor(points.len() / 2))
    add(middle, scale(unit(sub(middle, center)), offset))
  }
}
