#import "@preview/cetz:0.5.0": canvas, draw
#import draw: arc, bezier, circle, content, line, mark

#import "vectors.typ": add, sub, scale, magnitude, unit, rotate, midpoint, lerp, polar, step_forward
#import "geometry.typ": arc_center, arc_points, label_position

#let diagram(body, length: 1cm) = canvas(length: length, body)


#let put_label(position, body) = content(position, body)

#let vertex(position, radius: 0.045, fill: black) = {
  circle(position, radius: radius, fill: fill)
}

#let Dot(position, r: 0.05, fill: black) = vertex(position, radius: r, fill: fill)

#let defualt_stroke = black

#let default_stroke = black

#let premark(a, b, symbol: "stealth", fill: black, stroke: black) = {
  mark(b, step_forward(a, b), symbol: symbol, fill: fill, stroke: stroke)
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


#let ppa_arc(a, b, ang, re: 1, center_show: false, stroke: black) = {
  draw_curve(a, b, angle: ang, re: re, samples: 32, stroke: stroke)
  if center_show {
    let center = arc_center(a, b, ang, re: re)
    if center != none {
      Dot(center, r: 0.04, fill: gray)
    }
  }
}

#let dashed_line(a, b, node: 6, d: 0.08, stroke: black) = {
  let direction = sub(b, a)
  let dash_fraction = (1 - (node - 1) * d) / node
  let dash_vector = scale(direction, dash_fraction)
  let gap_vector = scale(direction, d)
  let start = a
  let stop = add(a, dash_vector)
  for i in range(node) {
    line(start, stop, stroke: stroke)
    start = add(stop, gap_vector)
    stop = add(start, dash_vector)
  }
}

#let twopoint_wave(a, b, orien: 1, amp: 1.2, stroke: black) = {
  let delta = sub(b, a)
  let control = add(add(a, delta), scale(rotate(delta, orien * 90deg), amp))
  bezier(a, b, control, stroke: stroke)
}

#let waveline(starts, ends, node: 10, stroke: black) = {
  photon(starts, ends, node: node, stroke: stroke)
}

#let waveline_group(start: (), end: (), node: 10, stroke: black) = {
  waveline(start, end, node: node, stroke: stroke)
}

#let no_match_cir(a, b, rate: 2, stroke: black) = {
  let c = add(a, scale(sub(a, b), 1 / rate))
  ppa_arc(a, c, 180deg, center_show: false, stroke: stroke)
  ppa_arc(c, b, 180deg, center_show: false, stroke: stroke)
}

#let fermion(
  a,
  b,
  angle: calc.inf,
  ang: none,
  re: 1,
  samples: 18,
  stroke: black,
  label: none,
  m: none,
  m_show: true,
  mark_show: true,
  label_offset: 0.18,
  vertex_show: false,
) = {
  let curve_angle = if ang == none { angle } else { ang }
  let shown_label = label
  if shown_label == none and m_show {
    shown_label = m
  }
  let points = arc_points(a, b, angle: curve_angle, re: re, samples: samples)
  draw_polyline(points, stroke: stroke)
  if mark_show {
    arrow_on(points, stroke: stroke, fill: stroke)
  }

  if shown_label != none {
    put_label(label_position(a, b, angle: curve_angle, re: re, offset: label_offset), shown_label)
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
  form: none,
  segments: 7,
  node: none,
  stroke: black,
  label: none,
  m: none,
  label_offset: 0.18,
  vertex_show: false,
) = {
  let scalar_style = if style != none {
    style
  } else if form == 1 or form == "1" or form == "plain" {
    "plain"
  } else {
    "dashed"
  }
  let segment_count = if node == none { segments } else { node }
  let shown_label = label
  if shown_label == none {
    shown_label = m
  }

  if scalar_style == "plain" {
    draw_curve(a, b, angle: angle, re: re, samples: 18, stroke: stroke)
  } else {
    let points = arc_points(a, b, angle: angle, re: re, samples: 2 * segment_count)
    for i in range(0, points.len() - 1, step: 2) {
      let start = if i == 0 { a } else { points.at(i) }
      let stop = if i + 1 == points.len() - 1 { b } else { points.at(i + 1) }
      line(start, stop, stroke: stroke)
    }
  }

  if shown_label != none {
    put_label(label_position(a, b, angle: angle, re: re, offset: label_offset), shown_label)
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
  node: none,
  orien: 1,
  amplitude: 0.1,
  stroke: black,
  label: none,
  m: none,
  label_offset: 0.22,
  vertex_show: false,
) = {
  let segment_count = if node == none { segments } else { node }
  let shown_label = label
  if shown_label == none {
    shown_label = m
  }
  let anchors = arc_points(a, b, angle: angle, re: re, samples: segment_count + 1)
  let side = orien

  for i in range(anchors.len() - 1) {
    let start = anchors.at(i)
    let stop = anchors.at(i + 1)
    let middle = midpoint(start, stop)
    let normal = scale(unit(rotate(sub(stop, start), 90deg)), amplitude * side)
    bezier(start, stop, add(middle, normal), stroke: stroke)
    side = side * -1
  }

  if shown_label != none {
    put_label(label_position(a, b, angle: angle, re: re, offset: label_offset), shown_label)
  }

  if vertex_show {
    vertex(a)
    vertex(b)
  }
}

#let ph(
  a,
  b,
  angle: calc.inf,
  stroke: defualt_stroke,
  orien: 1,
  node: 12,
  vertex_show: false,
  m: none,
) = {
  photon(
    a,
    b,
    angle: angle,
    stroke: stroke,
    orien: orien,
    node: node,
    vertex_show: vertex_show,
    m: m,
  )
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
  node: none,
  amplitude:none,
  radius: .1,
  stroke: black,
  label: none,
  m: none,
  label_offset: 0.5,
  vertex_show: false,
) = {
  let hole_count = if node == none { turns } else { node }
  let gluon_radius = if radius != none {
    radius
  } else if amplitude != none {
    amplitude
  } else {
    0.45
  }
  let gluon_form = if form == 2 or form == "2" or form == "spiral" {
    2
  } else {
    1
  }
  let shown_label = label
  if shown_label == none {
    shown_label = m
  }
  if gluon_form == 2 {
    spiral_segment(
      a,
      b,
      angle: angle,
      re: re,
      loops: hole_count,
      side: re,
      amplitude: gluon_radius,
      stroke: stroke,
    )
  } else {
    let anchors = arc_points(a, b, angle: angle, re: re, samples: hole_count + 1)
    let side = re
    for i in range(anchors.len() - 1) {
      coil_segment(
        anchors.at(i),
        anchors.at(i + 1),
        side: side,
        amplitude: gluon_radius,
        stroke: stroke,
      )
      side = side * -1
    }
  }

  if shown_label != none {
    put_label(label_position(a, b, angle: angle, re: re, offset: label_offset), shown_label)
  }

  if vertex_show {
    vertex(a)
    vertex(b)
  }
}

#let fermion_loop(a, b, stroke: black, mark_storke:black, vertex_show: false) = {
  let upper = arc_points(a, b, angle: 180deg, re: 1, samples: 21)
  let lower = arc_points(b, a, angle: 180deg, re: 1, samples: 21)
  draw_polyline(upper, stroke: stroke)
  draw_polyline(lower, stroke: stroke)
  arrow_on(upper, t: 0.5, stroke: mark_storke, fill: mark_storke)
  arrow_on(lower, t: 0.5, stroke: mark_storke, fill: mark_storke)

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

#let oval(center, long: 1, width: 1, fill: none, stroke: black) = {
  draw.scale(x: width, y: long)
  circle((center.at(0) / width, center.at(1) / long), fill: fill, stroke: stroke)
  draw.scale(x: 1 / width, y: 1 / long)
}

#let ox(position, r, angle: 45deg, stroke: black) = {
  circle(position, radius: r, stroke: stroke)
  let s1 = add(position, polar(r, angle))
  let e1 = add(position, polar(r, angle + 180deg))
  let s2 = add(position, polar(r, angle + 90deg))
  let e2 = add(position, polar(r, angle - 90deg))
  line(s1, e1, stroke: stroke)
  line(s2, e2, stroke: stroke)
}

#let Rot_group(body, angle, origin: (0, 0, 0)) = {
  draw.rotate(angle, origin: origin)
  body
}

#let axis(o, xlim: (-4, 4), ylim: (-4, 4), ticks: false, xticks: false, yticks: false) = {
  let show_x_ticks = xticks or ticks
  let show_y_ticks = yticks or ticks
  Dot(o)
  line((xlim.at(0), 0), (xlim.at(1), 0))
  line((0, ylim.at(0)), (0, ylim.at(1)))
  premark(o, (xlim.at(1), 0))
  premark(o, (0, ylim.at(1)))
  if show_x_ticks {
    for i in range(calc.floor(xlim.at(0)) + 1, calc.floor(xlim.at(1))) {
      Dot((i, 0), r: 0.035)
    }
  }
  if show_y_ticks {
    for i in range(calc.floor(ylim.at(0)) + 1, calc.floor(ylim.at(1))) {
      Dot((0, i), r: 0.035)
    }
  }
}

#let four_gluon_s(
  center,
  radius,
  alpha: 0.43,
  theta: 0deg,
  gluon_radius:.05,
  th: none,
  turns: 6,
  node: none,
  opening: 40deg,
  ang: none,
  stroke: black+.8pt,
) = {
  let used_theta = if th == none { theta } else { th }
  let used_turns = if node == none { turns } else { node }
  let used_opening = if ang == none { opening } else { ang }
  let left = add(center, polar(alpha * radius, used_theta + 180deg))
  let right = add(center, polar(alpha * radius, used_theta))
  let legs = (
    add(left, polar(radius, used_theta + 180deg - used_opening)),
    add(left, polar(radius, used_theta + 180deg + used_opening)),
    add(right, polar(radius, used_theta - used_opening)),
    add(right, polar(radius, used_theta + used_opening)),
  )
  let side_turns = calc.floor(used_turns * 1.8)
  (
    {
      let gluons(left,right,turns:none,stroke:stroke) = gluon(left,right,turns:turns,radius:gluon_radius,stroke:stroke)
      gluons(left, right, turns: used_turns,stroke: stroke)
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
  th: none,
  turns: 6,
  node: none,
  opening: 40deg,
  ang: none,
  stroke: black+.8pt,
) = {
  let channel = four_gluon_s(
    center,
    radius,
    alpha: alpha,
    theta: theta + 90deg,
    th: if th == none { none } else { th + 90deg },
    turns: turns,
    node: node,
    opening: opening,
    ang: ang,
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
