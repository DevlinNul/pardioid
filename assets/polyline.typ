#import "@local/pardioid:0.1.0": *

#set page(width: auto, height: auto, margin: 2pt)

// avoid zero in the parameter range
#parametric-curve-2d(
  vector-fn: p => {
    let t = p - 1.5
    (t, t * t * t - 3 * t * t - 2 * t)
  },
  t-range: Range(0, 5.1),
  geom-granularity: geom-presets.polyline,
  init-samples: 10,
  clip-box: none,
)

