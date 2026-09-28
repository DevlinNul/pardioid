#import "@local/pardioid:0.1.0": *

#set page(width: auto, height: auto, margin: 2pt)

// Set of power functions.
#canvas(viewport: auto, length: 1em, inset: 2pt, for alpha in range(-3, 4) {
  draw.curve(
    vector-fn: t => (t, calc.pow(t, alpha)),
    t-range: (-5, 5),
    stroke: 0.05em + oklch(70%, 0.15, 360deg * (alpha + 3) / 7),
  )
})
