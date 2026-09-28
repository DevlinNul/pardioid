#import "@local/pardioid:0.1.0": *

#set page(width: auto, height: auto, margin: 2pt)

#parametric-curve-2d(
  vector-fn: t => (t * t, calc.floor(t)),
  t-range: Range(-2, 2),
  detect-edge: true,
)
