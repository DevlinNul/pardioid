
#import "@preview/pardioid:0.1.0": *

#set page(width: auto, height: auto, margin: 0pt)

// A circle and a cardioid made of joined pieces.
#canvas(viewport: auto, length: 5em, inset: 2pt, {
  import draw: *
  merge-curve(fill: gradient.linear(..color.map.turbo, angle: -67deg), {
    curve(
      vector-fn: {
        import calc: *
        let den(t) = 4 - 3 * pow(cos(t), 2)
        let x-num(t) = 8 * pow(sin(t), 3)
        let y-num(t) = -3 * cos(t) * (3 - 2 * pow(cos(t), 2)) // originally -4 * cos(t) * (3 - 2 * pow(cos(t), 2))
        t => (x-num(t) / den(t), y-num(t) / den(t))
      },
      clip-box: none,
      t-range: (-calc.pi / 2, calc.pi / 2),
    )
    curve(
      vector-fn: {
        import calc: *
        t => (-1 * sin(t) + 1, 1 * cos(t))
      },
      t-range: (-calc.pi / 2, calc.pi / 2),
      clip-box: none,
    )
    curve(
      vector-fn: {
        import calc: *
        t => (-1 * sin(t) - 1, 1 * cos(t))
      },
      t-range: (-calc.pi / 2, calc.pi / 2),
      clip-box: none,
    )
  })
})
