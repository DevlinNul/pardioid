#import "@preview/tidy:0.4.3": *
#import "@local/pardioid:0.1.0"
#import "preamble.typ": *

// 给draw模块的每一个函数都加上一个实例


#import "my-tidy-style.typ" as style

#show link: set text(fill: blue)
// #show raw.where(block: false): it => box(it, inset: 2pt, radius: 0.5em, stroke: 0.3pt + black)


#let under-heavy-line(it, color: orange, depth: 0.5em, alpha: 25%, offset: auto) = {
  let s-color = color.transparentize(100% - alpha)
  let s-offset = if offset == auto { -depth / 4 } else { offset }
  underline(it, stroke: s-color + depth, evade: false, background: true, offset: s-offset)
}

#set raw(lang: "typ")

#show heading.where(level: 1): set align(center)
#show heading.where(level: 2): box.with(stroke: 0.3pt + blue, inset: 4pt, radius: 1em, fill: aqua.transparentize(50%))
// #show heading.where(level: 2): set text(size: 1.2em)
#show heading.where(level: 3): under-heavy-line
#show heading.where(level: 3): set text(size: 1.3em)

#let show-module = show-module.with(style: style, break-param-descriptions: true)
#let parse-module = parse-module.with(
  scope: (
    extract-def: extract-def,
    extract-doc: extract-doc,
  ),
)

#let label-prefix = "-"
#let resolve-module(path, ..args) = show-module(
  show-outline: false,
  parse-module(
    expand-macros(read(path)),
    label-prefix: label-prefix,
    ..args,
  ),
)

// #set heading(numbering: (..nums) => {
//   // A magic number from `HEADING_RULE` in "crates/typst-layout/src/rules.rs".
//   h(-0.3em)
// })
#set page(margin: (y: 2em))

#let display(body) = {
  block(stroke: aqua.transparentize(50%) + 0.03em, body)
}


#show: render-examples.with(
  scope: (display: display, pardioid: pardioid),
  layout: style.default-layout-example.with(ratio: 3),
)

#let my-ref(name, is-fn: true, label-prefix: label-prefix, show-name: none) = {
  link(label(label-prefix + name + if is-fn { "()" } else { none }), if show-name == none { name } else { show-name })
}

#let add-prefix(s) = {
  let lines = s.split("\n")
  lines.map(line => ">>> " + line).join("\n")
}



= Tutorial

== Getting Started

Pardioid mainly provides two functions: #my-ref("parametric-curve-2d") and #my-ref("canvas"). The former draws a single parametric curve, while the latter draws multiple parametric curves on the same canvas.

This package uses no `context`.

Note that the following are not yet supported: `mark`, `arrow`, content placement, and an inline style system.

=== parametric-curve-2d

To draw a single parametric curve, simply provide a two-dimensional vector-valued function `vector-fn`, a parameter range `t-range`, and a viewport.

For `vector-fn`, you may optionally wrap the return value in `Coord`. This is equivalent to writing an array directly, since `Coord` is defined as:
#extract-def("header.typ", id: "Coord")

For `t-range`, simply write it like a mathematical interval, optionally wrapped in `Range`. Here `Range` is defined as:
#extract-def("header.typ", id: "Range")
where `start` and `end` take values in the extended reals, namely $RR union {-oo, +oo}$.

Here is a simple example. `vector-fn` is the parametric equation of an ellipse, and its parameter range indicates that only half of the ellipse is drawn.
`viewport: auto` means the viewport is the actual bounding box of the drawn ellipse.
`length` is the screen length corresponding to one Cartesian coordinate unit, with a default value of `1em`. If the figure appears too small, you can increase it, for example to `25pt` or `3em`.

```example
#import "@local/pardioid:0.1.0"

#let display(body) = {
  block(stroke: aqua.transparentize(50%) + 0.03em, body)
}

#display(
  pardioid.parametric-curve-2d(
    vector-fn: t => (2 * calc.cos(t), 1 * calc.sin(t)),
    t-range: (0, calc.pi),
    viewport: auto,
    length: 3em,
  )
)
```

In the examples below, `#import "@local/pardioid:0.1.0"` and the definition of `display` are omitted by default.

`viewport` is either `auto` or of type `Axes`; `auto` is shorthand for `Axes(x: auto, y: auto)`. Here `x` and `y` are either `auto` or of type `Range`, representing the horizontal and vertical directions respectively. `auto` uses the curve's actual bounding box in that direction, while `Range` uses the given range.

`viewport` determines the occupied extent of the content. Curves may extend beyond the viewport; the overflowing part is still displayed but does not participate in the page flow.

```example
#import pardioid: *
#display(
  parametric-curve-2d(
    vector-fn: t => (1.2 * t, -2 * t * t),
    t-range: Range(0,6),
    viewport: auto,
    length: 1.2em
  )
)
```

```example
#import pardioid: Coord, Range, Axes, parametric-curve-2d
#display(
  parametric-curve-2d(
    vector-fn: t => Coord(1.2 * t, -2 * t * t),
    t-range: Range(0,6),
    viewport: Axes(x: (-5,1), y: auto)
  )
)
```

=== canvas

In a canvas, you can draw multiple curves at once in the same Cartesian coordinate system. A simple example:

```example
#display(pardioid.canvas(
  length: 1em,
  {
    import pardioid.draw: *
    curve(
      vector-fn: t => Coord(1.2 * t, -2 * t * t),
      t-range: Range(0,6),
    )
  }
))
```

This syntax is largely inspired by the canvas design of #link("https://typst.app/universe/package/cetz")[CeTZ]. Since the default `viewport` of canvas in Pardioid is `Axes(x: (-5,5), y: (-5,5))`, the output above has a lot of empty space. For bounded parametric curves, you can set `viewport` to `auto`.

Inside a canvas, you wrap drawing commands in a code block, and each command is a function from the draw module. In the example above, the `curve` function in the draw module is just `parametric-curve-2d` without the `viewport` and `length` parameters. These two parameters control the mapping from Cartesian coordinates to canvas coordinates, which should be handled by the canvas rather than by individual draw functions.

All currently available functions in the draw module are listed below. For more details, see #my-ref("Draw Module", is-fn: false, label-prefix: none).

#let draws = (
  "curve",
  "point",
  "line",
  "polyline",
  "polygon",
  "circle",
  "ellipse",
  "number-plane",
  "quad",
  "cubic",
  "merge-curve",
)
#for fn in draws {
  box(my-ref(fn), radius: 1em, inset: 0.3em, fill: gray) + h(0pt, weak: true)
}

In a canvas, elements are drawn in the order they appear, so later shapes are painted on top of earlier ones.

=== Basic Styles

In Pardioid, when an exported function supports `stroke`, it also supports `stroke-config`, whose type is `Stroke-config`. For more details, see #my-ref("Styles", is-fn: false, label-prefix: none).

When `stroke-mode` of `stroke-config` is #highlight("cover"), the `stroke` parameter is used directly.

When `stroke-mode` of `stroke-config` is #highlight("merge"), the stroke parameter is the result of merging `stroke`, `stroke-config.base-stroke`, and `default-stroke`. For more information, see #my-ref("stroke-config", is-fn: false).

```example
#display(pardioid.parametric-curve-2d(
  // In general, a single point is difficult to sample.
  vector-fn: t => (t, if t > 0 {1} else if t < 0 {-1} else {0}),
  t-range: (-2, 2),
  detect-edge: true,
  stroke: 1pt + black,
  // (cap: "butt",) because with no inheritance, cap == auto resolves to cap == "butt"
  stroke-config: pardioid.Stroke-config(stroke-mode: "cover")
))
```

```example
#display(pardioid.parametric-curve-2d(
  vector-fn: t => (t, if t > 0 {1} else if t < 0 {-1} else {0}),
  t-range: (-2, 2),
  detect-edge: true,
  stroke: 1pt + black,
  // (cap: "round",) because stroke does not explicitly set cap, so default-base-stroke.cap (== "round") is used
  stroke-config: pardioid.Stroke-config(stroke-mode: "merge")
))
```


== Basic Usage

=== Cardioid + Lissajous curve

```example
// A cardioid is placed inside a Lissajous curve.
#let fig = {
  import pardioid.draw: *
  // Cardioid.
  curve(
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
  curve(
    vector-fn: t => (2 * calc.sin(3 * t), 2 * calc.sin(2 * t)),
    t-range: (0, 2 * calc.pi),
    clip-box: none,
    fill: rgb("e6f2ff").transparentize(50%),
    stroke: blue,
  )
}

#display(
  pardioid.canvas(
    viewport: auto,
    // length: 1em,
    inset: (left: 2pt, y: -3pt),
    fig
  ),
)
```
Note that `fill-rule` alone cannot fully fill the "interior" of this Lissajous curve; this is a limitation of the fill rule.

=== merge-curve

Below we have three pieces of a single curve, two of which are semicircles. To make the drawing direction visible, each curve is cut short by subtracting `0.2` from the second argument of `Range`.

However, when applying `fill` to a merged curve, the drawing direction does not actually matter. The same is true for a `stroke` with a gradient, because Typst's `fill` and `stroke` are based on the content's bounding box rather than on the sample point order in `std.curve`.

#let merge-curve-demo = ```typ
#import pardioid.draw: *
#let body = curve(
  vector-fn: {
    import calc: *
    let den(t) = 4 - 3 * pow(cos(t), 2)
    let x-num(t) = 8 * pow(sin(t), 3)
    let y-num(t) = -3 * cos(t) * (3 - 2 * pow(cos(t), 2))
    t => Coord(x-num(t) / den(t), y-num(t) / den(t))
  },
  clip-box: none,
  t-range: Range(-calc.pi / 2, calc.pi / 2 - 0.2),
)
#let left-semi-circle = curve(
  vector-fn: {
    import calc: *
    t => Coord(-1 * sin(t) - 1, 1 * cos(t))
  },
  t-range: Range(-calc.pi / 2, calc.pi / 2 - 0.2),
  clip-box: none,
)
#let right-semi-circle = curve(
   vector-fn: {
      import calc: *
      t => Coord(-1 * sin(t) + 1, 1 * cos(t))
    },
    t-range: Range(-calc.pi / 2, calc.pi / 2 - 0.2),
    clip-box: none,
)
```
#let merge-curve-demo-partial1 = ```typ
  #for element in (body, right-semi-circle, left-semi-circle) {
    display(pardioid.canvas(number-plane() + element, viewport: Axes(x: Range(-2,2), y: Range(-2,2))))
  }
```
#let merge-curve-demo-partial2 = ```typ
  #display(pardioid.canvas(
    viewport: auto,
    length: 1em,
    inset: 2pt,
    {
      import pardioid.draw: *
      merge-curve(
        fill: gradient.linear(..color.map.turbo, angle: -67deg),
        {
          body
          left-semi-circle
          right-semi-circle
        }
      )
    }
  ))
```

#raw(
  lang: "example",
  merge-curve-demo.text + "\n" + merge-curve-demo-partial1.text,
)

Then applying `fill` to the merged curve.
#raw(
  lang: "example",
  add-prefix(merge-curve-demo.text) + "\n" + merge-curve-demo-partial2.text,
)

=== clip-box

For a parametric curve, you can specify a `clip-box`. Pardioid uses the Liang–Barsky algorithm to clip away the parts of the curve outside the `clip-box` and keep the parts inside it unchanged.

```example
#import pardioid: *
#display(
  parametric-curve-2d(
    vector-fn: t => Coord(calc.cos(t), calc.sin(t)),
    t-range: Range(0, 2 * calc.pi),
    clip-box: Axes(x: (0,2), y: Range(-1/2, 1/2)),
    length: 5em,
  )
)
```

`clip-box` may be more useful for functions in the draw module that support it, since it lets a single curve in a canvas display only the portion within a given rectangle.

```example
#import pardioid: *
#display(
  canvas(
    viewport: (x: (-2, 4), y: auto),
    {
      draw.number-plane()
      // A full circle, clipped to only the first quadrant.
      draw.curve(
        vector-fn: t => Coord(calc.cos(t), calc.sin(t)),
        t-range: Range(0, calc.pi * 2),
        clip-box: Axes(x: Range(0, 1), y: Range(0, 1)),
      )
      draw.curve(
        vector-fn: t => (3 * calc.cos(t), 2 * calc.sin(t)),
        t-range: (0, calc.pi * 2),
      )
    },
  ),
)
```

=== detect-edge

See #my-ref("parametric-curve-2d.detect-edge", is-fn: false, show-name: "detect-edge").

```example
#pardioid.parametric-curve-2d(
  vector-fn: t => (t, calc.floor(t)),
  t-range: (-5, 5),
  length: 0.5em
)
```


```example
#pardioid.parametric-curve-2d(
  vector-fn: t => (t, calc.floor(t)),
  t-range: (-5, 5),
  length: 0.5em,
  detect-edge: true
)
```
== Advanced

=== Sampler

Pardioid has two samplers for `draw.curve` and `parametric-curve-2d`: a uniform sampler and a geometry sampler. When sampling a curve, it first uses the uniform sampler (controlled by `init-samples`) and then the geometry sampler (controlled by `geom-granularity` and `max-depth`).

The geometry sampler uses `geom-granularity` to decide whether a sampling interval is acceptable. If it is acceptable, linear interpolation is considered a good enough approximation of the local curve, and the interval is drawn as a single line segment connecting its endpoints. If not, the interval is bisected and the subintervals are checked in the same way. If `max-depth` is reached and a subinterval is still unacceptable, the local parameter speed is too high for linear interpolation to be reliable, so only the interval's endpoints are drawn, with no line between them.

With this sampling scheme, you can use a coarser `geom-granularity` (`geom-presets.coarse`) for smooth curves with well-behaved parameterizations to get faster processing, use a finer granularity (`geom-presets.fine`) for pathological parametric curves to ensure correct rendering, and use special `geom-granularity` presets to draw polyline charts (`geom-presets.polyline`) and scatter plots (`geom-presets.pointwise`).

```example
#display(pardioid.parametric-curve-2d(
  vector-fn: t => (t, t * t),
  t-range: (-1, 5),
  init-samples: 20,
  max-depth: 1,
  geom-granularity: pardioid.geom-presets.pointwise
))
```

To support sampling intervals containing `float.inf`, an $epsilon$ (epsilon-for-float) is necessary to avoid division-by-zero errors. However, unconditionally adding this $epsilon$ can flip the sign of sign-preserving intervals and introduce unexpected discontinuities. To avoid this, Pardioid splits the parameter range so that $0$ is never inside any of the resulting pieces, and then applies $+ epsilon$ to positive intervals and $- epsilon$ to negative intervals to preserve the sign. This also makes it convenient to map `float.inf` to a finite number so that sampling can proceed. However, this causes the sampling density with respect to the parameter $t$ to be inconsistent on the two sides of $t = 0$, as shown in the example above. If you need uniform sampling density, draw two parametric curves manually, with $0$ not inside the parameter range of either curve. Alternatively, you can shift the parameter so that $t$ does not cross $0$ when producing the desired curve.

```example
// Shift the parameter
#display(pardioid.parametric-curve-2d(
  vector-fn: t => ((t - 1), (t - 1) * (t - 1)),
  t-range: (0, 6),
  init-samples: 20,
  max-depth: 1,
  geom-granularity: pardioid.geom-presets.pointwise
))
```

Since `pointwise` is implemented as never acceptable, it always triggers subdivision. When using `pointwise`, lower `max-depth` and `init-samples`, and if necessary set `max-depth` to 1. Otherwise, recursing to the maximum depth everywhere will exhaust your memory and CPU.

`polyline` is always accepted, so it never triggers subdivision and `max-depth` has no effect.

```example
#display(pardioid.parametric-curve-2d(
  vector-fn: t => ((t - 1), (t - 1) * (t - 1)),
  t-range: (0, 6),
  stroke: (join: "miter"),
  init-samples: 20,
  // `max-depth` doesn't matter.
  max-depth: 100,
  geom-granularity: pardioid.geom-presets.polyline
))
```

For the meaning of each key in `geom-granularity`, see #my-ref("parametric-curve-2d.geom-granularity", is-fn: false, show-name: "geom-granularity").


#set page(columns: 2, margin: (x: 2.5em, y: 2em))

#place(top + center, scope: "parent", float: true)[
  = Reference
]


// == Public

#resolve-module("/src/lib.typ", name: "Public")

// == Draw Module

#resolve-module("/src/draw.typ", name: "Draw Module") #label("Draw Module")

// == Styles

#resolve-module("/docs/styles.typ", name: "Styles") #label("Styles")

#set page(columns: 1)

= Manual For Developers


