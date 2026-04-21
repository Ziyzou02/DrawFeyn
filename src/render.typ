#import "@preview/cetz:0.5.0": canvas, draw
#import draw: bezier, circle, content, line, mark

#import "vectors.typ": add, sub, scale, magnitude, unit, rotate, midpoint, lerp, polar
#import "geometry.typ": arc_points, label_position

#let diagram(body, length: 1cm) = canvas(length: length, body)


#let put_label(position, body) = content(position, body)

#let vertex(position, radius: 0.045, fill: black) = {
  circle(position, radius: radius, fill: fill)
}

#let draw_polyline(points, stroke: black) = {
  for i in range(points.len() - 1) {
    line(points.at(i), points.at(i + 1), stroke: stroke)
  }
}

#let arrow_on(points, t: 0.58, stroke: black, fill: black) = {
  let segments = points.len() - 1
  if segments > 0 {
    let index = calc.floor((segments - 1) * t)
    if index < 0 {
      index = 0
    }
    if index > segments - 1 {
      index = segments - 1
    }
    mark(
      points.at(index),
      points.at(index + 1),
      symbol: "stealth",
      stroke: stroke,
      fill: fill,
    )
  }
}

#let draw_curve(a, b, angle: calc.inf, re: 1, samples: 16, stroke: black) = {
  let points = arc_points(a, b, angle: angle, re: re, samples: samples)
  draw_polyline(points, stroke: stroke)
}

#let fermion(
  a,
  b,
  angle: calc.inf,
  re: 1,
  samples: 18,
  stroke: black,
  label: none,
  mark_show: true,
  label_offset: 0.18,
  vertex_show: false,
) = {
  let points = arc_points(a, b, angle: angle, re: re, samples: samples)
  draw_polyline(points, stroke: stroke)
  if mark_show {
    arrow_on(points, stroke: stroke, fill: stroke)
  }

  if label != none {
    put_label(label_position(a, b, angle: angle, re: re, offset: label_offset), label)
  }

  if vertex_show {
    vertex(a)
    vertex(b)
  }
}

#let scalar(
  a,
  b,
  angle: calc.inf,
  re: 1,
  style: none,
  segments: 7,
  stroke: black,
  label: none,
  label_offset: 0.18,
  vertex_show: false,
) = {
  let scalar_style = if style != none {
    style
  } else {
    "dashed"
  }

  if scalar_style == "plain" {
    draw_curve(a, b, angle: angle, re: re, samples: 18, stroke: stroke)
  } else {
    let points = arc_points(a, b, angle: angle, re: re, samples: 2 * segments)
    for i in range(0, points.len() - 1, step: 2) {
      let start = if i == 0 { a } else { points.at(i) }
      let stop = if i + 1 == points.len() - 1 { b } else { points.at(i + 1) }
      line(start, stop, stroke: stroke)
    }
  }

  if label != none {
    put_label(label_position(a, b, angle: angle, re: re, offset: label_offset), label)
  }

  if vertex_show {
    vertex(a)
    vertex(b)
  }
}

#let photon(
  a,
  b,
  angle: calc.inf,
  re: 1,
  segments: 12,
  orien: 1,
  amplitude: 0.1,
  stroke: black,
  label: none,
  label_offset: 0.22,
  vertex_show: false,
) = {
  let anchors = arc_points(a, b, angle: angle, re: re, samples: segments + 1)
  let side = orien

  for i in range(anchors.len() - 1) {
    let start = anchors.at(i)
    let stop = anchors.at(i + 1)
    let middle = midpoint(start, stop)
    let normal = scale(unit(rotate(sub(stop, start), 90deg)), amplitude * side)
    bezier(start, stop, add(middle, normal), stroke: stroke)
    side = side * -1
  }

  if label != none {
    put_label(label_position(a, b, angle: angle, re: re, offset: label_offset), label)
  }

  if vertex_show {
    vertex(a)
    vertex(b)
  }
}

#let coil_segment(a, b, side: 1, amplitude: 0.45, stroke: black) = {
  let delta = sub(b, a)
  let normal = scale(unit(rotate(delta, 90deg)), amplitude * magnitude(delta) * side)
  let half = midpoint(a, b)
  bezier(a, half, add(lerp(a, b, 0.25), normal), stroke: stroke)
  bezier(half, b, add(lerp(a, b, 0.75), normal), stroke: stroke)
}

#let polyline_length(points) = {
  let total = 0
  for i in range(points.len() - 1) {
    total = total + magnitude(sub(points.at(i + 1), points.at(i)))
  }
  total
}

#let polyline_frame(points, distance) = {
  if points.len() < 2 {
    return ((0, 0), (1, 0))
  }

  let remaining = distance
  if remaining <= 0 {
    return (points.at(0), sub(points.at(1), points.at(0)))
  }

  for i in range(points.len() - 1) {
    let start = points.at(i)
    let stop = points.at(i + 1)
    let segment = sub(stop, start)
    let segment_length = magnitude(segment)

    if segment_length != 0 {
      if remaining <= segment_length or i == points.len() - 2 {
        let ratio = calc.min(1, remaining / segment_length)
        return (lerp(start, stop, ratio), segment)
      }

      remaining = remaining - segment_length
    }
  }

  (
    points.at(points.len() - 1),
    sub(points.at(points.len() - 1), points.at(points.len() - 2)),
  )
}

#let gluon_tail_length(length, loops, radius) = {
  let pitch = length / calc.max(loops, 1)
  calc.min(0.35 * length, calc.max(2 * radius, 0.6 * pitch))
}

#let spiral_segment(
  a,
  b,
  angle: calc.inf,
  re: 1,
  loops: 5,
  side: 1,
  amplitude: 0.45,
  samples_per_loop: 24,
  stroke: black,
) = {
  let loop_count = if loops < 1 { 1 } else { loops }
  let loop_samples = if samples_per_loop < 4 { 4 } else { samples_per_loop }
  let centerline = arc_points(
    a,
    b,
    angle: angle,
    re: re,
    samples: loop_count * loop_samples + 1,
  )
  let center_length = polyline_length(centerline)
  let loop_radius = amplitude
  let tail_length = gluon_tail_length(center_length, loop_count, loop_radius)
  let core_length = calc.max(center_length - tail_length, center_length / 4)
  let fake_frame = polyline_frame(centerline, core_length)
  let fake_end = fake_frame.at(0)
  let fake_tangent = unit(fake_frame.at(1))
  let fake_normal = unit(rotate(fake_tangent, 90deg))
  let end_frame = polyline_frame(centerline, center_length)
  let end_tangent = unit(end_frame.at(1))
  let end_normal = unit(rotate(end_tangent, 90deg))
  let tail_rise = 4 * loop_radius / 3
  let tail_mid = midpoint(fake_end, b)
  let tail_control_start = add(add(fake_end, scale(fake_tangent, tail_length / 3)), scale(fake_normal, side * tail_rise))
  let tail_control_end = add(add(b, scale(end_tangent, -tail_length / 3)), scale(end_normal, side * tail_rise))
  let core_points = ()

  for i in range(loop_count * loop_samples + 1) {
    let t = i / (loop_count * loop_samples)
    let phase = 360deg * loop_count * t
    let travel = t * core_length - loop_radius * calc.cos(phase) + loop_radius
    let frame = polyline_frame(centerline, travel)
    let base = frame.at(0)
    let tangent = frame.at(1)
    let normal = unit(rotate(tangent, 90deg))
    let sideways = scale(normal, side * loop_radius * calc.sin(phase))
    core_points = core_points + (add(base, sideways),)
  }

  draw_polyline(core_points, stroke: stroke)
  bezier(fake_end, tail_mid, tail_control_start, stroke: stroke)
  bezier(tail_mid, b, tail_control_end, stroke: stroke)
}

#let gluon(
  a,
  b,
  angle: calc.inf,
  re: 1,
  form: 2,
  turns: 10,
  radius: .1,
  stroke: black,
  label: none,
  label_offset: 0.5,
  vertex_show: false,
) = {
  let gluon_form = if form == 2 or form == "2" or form == "spiral" {
    2
  } else {
    1
  }
  if gluon_form == 2 {
    spiral_segment(
      a,
      b,
      angle: angle,
      re: re,
      loops: turns,
      side: re,
      amplitude: radius,
      stroke: stroke,
    )
  } else {
    let anchors = arc_points(a, b, angle: angle, re: re, samples: turns + 1)
    let side = re
    for i in range(anchors.len() - 1) {
      coil_segment(
        anchors.at(i),
        anchors.at(i + 1),
        side: side,
        amplitude: radius,
        stroke: stroke,
      )
      side = side * -1
    }
  }

  if label != none {
    put_label(label_position(a, b, angle: angle, re: re, offset: label_offset), label)
  }

  if vertex_show {
    vertex(a)
    vertex(b)
  }
}

#let fermion_loop(a, b, stroke: black, mark_stroke:black, vertex_show: false) = {
  let upper = arc_points(a, b, angle: 180deg, re: 1, samples: 21)
  let lower = arc_points(b, a, angle: 180deg, re: 1, samples: 21)
  draw_polyline(upper, stroke: stroke)
  draw_polyline(lower, stroke: stroke)
  arrow_on(upper, t: 0.5, stroke: mark_stroke, fill: mark_stroke)
  arrow_on(lower, t: 0.5, stroke: mark_stroke, fill: mark_stroke)

  if vertex_show {
    vertex(a)
    vertex(b)
  }
}

#let bubble(position, radius: 0.32, fill: luma(235), stroke: black, body: none) = {
  circle(position, radius: radius, fill: fill, stroke: stroke)
  if body != none {
    put_label(position, body)
  }
}

#let four_gluon_s(
  center,
  radius,
  alpha: 0.43,
  theta: 0deg,
  gluon_radius:.05,
  turns: 6,
  opening: 40deg,
  stroke: black+.8pt,
) = {
  let left = add(center, polar(alpha * radius, theta + 180deg))
  let right = add(center, polar(alpha * radius, theta))
  let legs = (
    add(left, polar(radius, theta + 180deg - opening)),
    add(left, polar(radius, theta + 180deg + opening)),
    add(right, polar(radius, theta - opening)),
    add(right, polar(radius, theta + opening)),
  )
  let side_turns = calc.floor(turns * 1.8)
  (
    {
      let gluons(left,right,turns:none,stroke:stroke) = gluon(left,right,turns:turns,radius:gluon_radius,stroke:stroke)
      gluons(left, right, turns: turns,stroke: stroke)
      gluons(left, legs.at(0), turns: side_turns, stroke: stroke)
      gluons(left, legs.at(1), turns: side_turns, stroke: stroke)
      gluons(right, legs.at(2), turns: side_turns, stroke: stroke)
      gluons(right, legs.at(3), turns: side_turns, stroke: stroke)
    },
    legs,
  )
}

#let four_gluon_t(
  center,
  radius,
  alpha: 0.43,
  theta: 0deg,
  turns: 6,
  opening: 40deg,
  stroke: black+.8pt,
) = {
  let channel = four_gluon_s(
    center,
    radius,
    alpha: alpha,
    theta: theta + 90deg,
    turns: turns,
    opening: opening,
    stroke: stroke,
  )
  (
    channel.at(0),
    (
      channel.at(1).at(3),
      channel.at(1).at(0),
      channel.at(1).at(1),
      channel.at(1).at(2),
    ),
  )
}
