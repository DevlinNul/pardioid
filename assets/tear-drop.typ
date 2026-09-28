#import "@local/pardioid:0.1.0": *

#set page(width: auto, height: auto, margin: 2pt)

#canvas(length: 10em, viewport: auto, {
  import draw: *

  let water-gradient = gradient.radial(
    (rgb("fafafa00"), 0%),
    (rgb("f3f9fc77"), 15%),
    (rgb("92bddaff"), 60%),
    (rgb("2870aebb"), 100%),
    center: (50%, 50%),
    focal-center: (30%, 75%), // 绕原点旋转后重新计算的焦点
    focal-radius: 0.5%,
  )

  let scale = 0.1

  let f(t) = {
    let num-x = 6 * calc.cos(2 * t) - 3 * calc.cos(4 * t)
    let num-y = 3 * calc.sin(4 * t) - 6 * calc.sin(2 * t)
    let den = 5 - 4 * calc.cos(2 * t)

    let x0 = (20 * num-x / den - 15) * scale
    let y0 = (20 * num-y / den) * scale

    let x = -y0
    let y = x0

    (x, y)
  }

  curve(
    vector-fn: f,
    t-range: (0, 2 * calc.pi),
    fill: water-gradient,
    stroke: none,
    init-samples: 300,
  )
})
