#import "@preview/pardioid:0.1.0": *

#set page(width: auto, height: auto, margin: 2pt)

#parametric-curve-2d(
  vector-fn: t => {
    let amplitude = t => (1 - calc.exp(-t))
    (amplitude(t) * calc.cos(t), amplitude(t) * calc.sin(t))
  },
  t-range: (-1, float.inf),
  clip-box: none,
  length: 3em,
  max-depth: 8,
)
