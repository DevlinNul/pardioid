#import "@local/pardioid:0.1.0": *

#set page(width: auto, height: auto, margin: 0pt)

#let display(body) = {
  block(stroke: aqua.transparentize(50%) + 0.03em, body)
}


// 一个圆和一个拼接的心形线
// A circle and a cardioid made of joined pieces.
#display(canvas(viewport: auto, length: 5em, inset: 2pt, {
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
}))
