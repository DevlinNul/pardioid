#import "@preview/pardioid:0.1.0": *

#set page(width: auto, height: auto, margin: 2pt)

#canvas(
  viewport: auto,
  // length: 1em,
  inset: 2pt,
  {
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
    // Lissajous curve.
    draw.curve(
      vector-fn: t => (2 * calc.sin(3 * t), 2 * calc.sin(2 * t)),
      t-range: (0, 2 * calc.pi),
      clip-box: none,
      fill: rgb("e6f2ff").transparentize(50%),
      stroke: blue,
      geom-granularity: geom-presets.pointwise,
      max-depth: 3,
      init-samples: 40,
    )
  },
)
