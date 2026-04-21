#let add(a, b) = a.zip(b).map(pair => pair.at(0) + pair.at(1))

#let scale(vector, factor) = vector.map(value => value * factor)

#let sub(a, b) = add(a, scale(b, -1))

#let sum(values) = {
  let total = 0
  for value in values {
    total = total + value
  }
  total
}

#let magnitude(vector) = calc.sqrt(sum(vector.map(value => value * value)))

#let norm(vector) = magnitude(vector)

#let vec_sum(values) = sum(values)

#let dot(a, b) = sum(a.zip(b).map(pair => pair.at(0) * pair.at(1)))

#let inner_product(a, b) = dot(a, b)

#let sign(value) = if value == 0 { 0 } else { value / calc.abs(value) }

#let sgn(value) = sign(value)

#let unit(vector) = {
  let length = magnitude(vector)
  if length == 0 {
    (0, 0)
  } else {
    scale(vector, 1 / length)
  }
}

#let rotate(vector, angle) = (
  calc.cos(angle) * vector.at(0) - calc.sin(angle) * vector.at(1),
  calc.sin(angle) * vector.at(0) + calc.cos(angle) * vector.at(1),
)

#let rot_vec_2dim(angle, vector) = rotate(vector, angle)

#let midpoint(a, b) = scale(add(a, b), 0.5)

#let lerp(a, b, t) = add(scale(a, 1 - t), scale(b, t))

#let line_div(a, b, lambda) = add(scale(a, lambda), scale(b, 1 - lambda))

#let step_forward(a, b) = add(b, sub(b, a))

#let polar(radius, angle) = (
  radius * calc.cos(angle),
  radius * calc.sin(angle),
)

#let polar_crd(radius, angle) = polar(radius, angle)

#let arc_angel2crd(position, angle, radius) = add(position, polar(radius, angle))

#let angle_from(origin, point) = {
  let dx = point.at(0) - origin.at(0)
  let dy = point.at(1) - origin.at(1)

  if dx == 0 {
    if dy >= 0 {
      90deg
    } else {
      270deg
    }
  } else {
    let angle = calc.atan(dy / dx)
    if dx < 0 {
      angle = angle + 180deg
    } else if dy < 0 {
      angle = angle + 360deg
    }

    if angle < 0deg {
      angle + 360deg
    } else {
      angle
    }
  }
}

#let crd2angel(position, coordinate) = angle_from(position, coordinate)
