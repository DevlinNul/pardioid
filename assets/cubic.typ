#import "@local/pardioid:0.1.0": *

#set page(width: auto, height: auto, margin: 2pt)

// Since a `point`'s bounding box is a single point (the center of the circle for `cap == "round"` or of the square for `cap == "square"`), setting `viewport` to `auto` may not fully contain the rendered point.
// This behavior is expected.
// If you need the `point`'s shape to lie entirely within the viewport, adjust the canvas's `inset`, for example `inset = point.width / 2`.
#canvas(viewport: auto, length: 3pt, {
  import draw: *

  let start = (0, -30)
  let end = (100, 50)
  let control-start = (10, 10)
  let control-end = (80, -20)
  point(control-start)
  point(control-end)
  cubic(start, end, control-start: control-start, control-end: control-end)
})
