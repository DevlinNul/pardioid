#import "@local/pardioid:0.1.0": *

#let display(body) = {
  block(stroke: aqua.transparentize(50%) + 0.03em, body)
}


// 一个圆和一个拼接的心形线
// A circle and a cardioid made of joined pieces.
#display(
  canvas(
    viewport: auto,
    length: 1em,
    inset: 2pt,
    {
      draw.merge-curve(
        fill: purple,
        {
          draw.merge-curve(fill: gradient.linear(..color.map.turbo, angle: -67deg), {
            (draw.curve)(
              vector-fn: {
                import calc: *
                let den(t) = 4 - 3 * pow(cos(t), 2)
                let x-num(t) = 8 * pow(sin(t), 3)
                let y-num(t) = -3 * cos(t) * (3 - 2 * pow(cos(t), 2)) // originally -4 * cos(t) * (3 - 2 * pow(cos(t), 2))
                t => (x-num(t) / den(t), y-num(t) / den(t))
              },
              clip-box: none,
              t-range: (-calc.pi / 2, calc.pi / 2),
              // fill: black,
            )
            (draw.curve)(
              vector-fn: {
                import calc: *
                t => (-1 * sin(t) + 1, 1 * cos(t))
              },
              t-range: (-calc.pi / 2, calc.pi / 2),
              clip-box: none,
            )
            (draw.curve)(
              vector-fn: {
                import calc: *
                t => (-1 * sin(t) - 1, 1 * cos(t))
              },
              t-range: (-calc.pi / 2, calc.pi / 2),
              clip-box: none,
            )
          })
          draw.curve(
            vector-fn: {
              import calc: *
              t => (2.1 * cos(t), 1.5 * sin(t))
            },
            t-range: (0, 2 * calc.pi),
            clip-box: none,
            stroke: white,
            // fill: purple,
          )
        },
      )
    },
  ),
)

// 利萨如曲线内部放置一个心形线
// A cardioid is placed inside a Lissajous curve.
#display(
  canvas(
    viewport: auto,
    // length: 1em,
    inset: 2pt,
    {
      // 心形线
      // Cardioid.
      draw.curve(
        vector-fn: {
          import calc: *
          t => (
            1.6 * pow(sin(t), 3),
            1.3 * cos(t) - 0.5 * cos(2 * t) - 0.2 * cos(3 * t) - 0.1 * cos(4 * t),
          )
        },
        t-range: (0, 2 * calc.pi),
        stroke: red + 1.2pt,
        fill: rgb(255, 180, 180, 120),
      )
      // 利萨茹曲线
      // Lissajous curve.
      draw.curve(
        vector-fn: t => (2 * calc.sin(3 * t), 2 * calc.sin(2 * t)),
        t-range: (0, 2 * calc.pi),
        clip-box: none,
        fill: rgb("e6f2ff").transparentize(50%),
        stroke: blue,
      )
    },
  ),
)


// Set of power functions.
#display(
  canvas(
    viewport: auto,
    length: 1em,
    inset: 2pt,
    for alpha in range(-3, 4) {
      draw.curve(
        vector-fn: t => (t, calc.pow(t, alpha)),
        t-range: (-5, 5),
        stroke: 0.05em + oklch(70%, 0.15, 360deg * (alpha + 3) / 7),
      )
    },
  ),
)


#display(parametric-curve-2d(
  vector-fn: t => {
    let amplitude = t => (1 - calc.exp(-t))
    (amplitude(t) * calc.cos(t), amplitude(t) * calc.sin(t))
  },
  t-range: (0, float.inf),
  clip-box: none,
  length: 3em,
))

#display(parametric-curve-2d(
  vector-fn: t => (t * (t - 1) / (t + 1), calc.floor(t * t * t) / 20),
  t-range: (-10, 5),
  detect-edge: true,
))

#display(parametric-curve-2d(
  vector-fn: t => {
    import calc: floor, pow
    (
      t,
      t * floor(t * t)
        - 2 / 3 * pow(floor(t * t), 3 / 2)
        - 1 / 2 * pow(floor(t * t), 1 / 2)
        + if t > 1 { 1 / 6 } else { 0 },
    )
  },
  t-range: (0, 5),
  detect-edge: true,
))


#display(parametric-curve-2d(
  vector-fn: t => {
    (t, t / calc.abs(t))
  },
  t-range: (-5, 5),
  detect-edge: true,
))

#display(parametric-curve-2d(
  vector-fn: t => {
    (t, calc.sin(1 / t))
  },
  t-range: (-5, 5),
  clip-box: (x: none, y: (-0.8, 3)),
))

#display(parametric-curve-2d(
  vector-fn: t => {
    (t, 1 / t)
  },
  t-range: (-5, 5),
))


#display(parametric-curve-2d(
  vector-fn: t => {
    (t, 1 / (t * t))
  },
  t-range: (-5, 5),
))

#display(parametric-curve-2d(
  vector-fn: t => (t, calc.atan2(t, t / calc.abs(t)).rad()),
  t-range: (-10, 10),
  detect-edge: true,
  // x-range: (-5, 5),
  // y-range: (-5, 5),
))

#display(parametric-curve-2d(
  vector-fn: t => (t, 1 / calc.ln(1 + calc.abs(t) + 1 / calc.abs(t))),
  t-range: (-5, 5),
  // detect-edge: true,
  // x-range: (-5, 5),
  // y-range: (-5, 5),
))

#display(parametric-curve-2d(
  vector-fn: t => (t, calc.atan2(t, t / calc.abs(t)).rad()),
  t-range: (-10, 10),
  detect-edge: true,
  // x-range: (-5, 5),
  // y-range: (-5, 5),
))

#display(parametric-curve-2d(
  vector-fn: t => (t, calc.exp(1 / t)),
  t-range: (-10, 10),
  // x-range: (-5, 5),
  // y-range: (-5, 5),
))

#display(parametric-curve-2d(
  vector-fn: t => (t, t * calc.sin(1 / (t + 1))),
  t-range: (-10, 10),
  // x-range: (-5, 5),
  // y-range: (-5, 5),
))

#display(parametric-curve-2d(
  vector-fn: t => (t, t * calc.sin(5 / (t))),
  t-range: (-5, 8),
  length: 1em,
  clip-box: (x: none, y: (-0.5, 10)),
))

#display(
  canvas(
    viewport: (x: (-2, 4), y: auto),
    {
      draw.curve(
        vector-fn: t => (calc.cos(t), calc.sin(t)),
        t-range: (0, calc.pi * 2),
        clip-box: (x: (0, 1), y: (0, 1)),
      )
      draw.curve(
        vector-fn: t => (3 * calc.cos(t), 2 * calc.sin(t)),
        t-range: (0, calc.pi * 2),
      )
    },
  ),
)


#display(
  parametric-curve-2d(
    vector-fn: t => (3 * calc.cos(t), 2 * calc.sin(t)),
    t-range: (0, calc.pi * 2),
    clip-box: (x: (-2, 2.8), y: (-5, 5)),
    length: 0.5em,
    viewport: auto,
  ),
)
