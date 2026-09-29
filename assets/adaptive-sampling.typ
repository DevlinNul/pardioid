#import "@preview/pardioid:0.1.0": *

#set page(width: auto, height: auto, margin: 2pt)

#let epsilon-for-algo = 1e-6

// The threshold in this function is a bit arbitrary; I haven't found a better algorithm yet.
#let real-gcd(a, b) = {
  import calc: abs, floor
  let abs-a = abs(a)
  let abs-b = abs(b)

  while abs-b > epsilon-for-algo / 100 {
    let q = floor(abs-a / abs-b)
    let r = abs-a - q * abs-b
    abs-a = abs-b
    abs-b = r
  }
  return if abs-a < epsilon-for-algo {
    none
  } else {
    abs-a
  }
}



#let envelope(
  omega_1: 3,
  omega_2: 2,
  r_1: 2,
  r_2: 0,
  ..args,
) = {
  assert(r_1 >= 0 and r_2 >= 0, message: "Radius must be non-negative.")
  let u(t) = omega_1 * (r_1 * calc.cos((omega_1 - omega_2) * t) - r_2)
  let v(t) = omega_2 * (r_2 * calc.cos((omega_1 - omega_2) * t) - r_1)
  let factor(t) = (
    (u(t) * r_2 + v(t) * r_1) / (u(t) * u(t) + v(t) * v(t) + 2 * u(t) * v(t) * calc.cos((omega_1 - omega_2) * t))
  )
  let para-x(t) = if r_1 - r_2 != 0 {
    factor(t) * (u(t) * calc.cos(omega_2 * t) + v(t) * calc.cos(omega_1 * t))
  } else {
    // r_1 == r_2
    let r = r_1
    (
      (r * (omega_1 + omega_2))
        / (omega_1 * omega_1 + omega_2 * omega_2 + 2 * omega_1 * omega_2 * calc.cos((omega_1 - omega_2) * t))
        * (omega_1 * calc.cos(omega_2 * t) + omega_2 * calc.cos(omega_1 * t))
    )
  }
  let para-y(t) = if r_1 != r_2 {
    factor(t) * (u(t) * calc.sin(omega_2 * t) + v(t) * calc.sin(omega_1 * t))
  } else {
    // r_1 == r_2
    let r = r_1
    (
      (r * (omega_1 + omega_2))
        / (omega_1 * omega_1 + omega_2 * omega_2 + 2 * omega_1 * omega_2 * calc.cos((omega_1 - omega_2) * t))
        * (omega_1 * calc.sin(omega_2 * t) + omega_2 * calc.sin(omega_1 * t))
    )
  }
  // let T = 2 * calc.pi / calc.gcd(calc.abs(omega_1), calc.abs(omega_2))
  // let T = calc.pi
  assert.eq(r_1 == 0 and r_2 == 0, false)
  let T = if r_1 == 0 {
    2 * calc.pi / real-gcd(2 * omega_1, omega_2)
  } else if r_2 == 0 {
    2 * calc.pi / real-gcd(omega_1, 2 * omega_2)
  } else {
    2 * calc.pi / real-gcd(omega_1, omega_2)
  }
  parametric-curve-2d(
    vector-fn: t => (para-x(t), para-y(t)),
    t-range: (0, T),
    clip-box: none,
    ..args.named(),
  )
}

#grid(
  columns: 3,
  align: horizon,
  gutter: 1em,
  envelope(omega_1: 2, omega_2: 1, r_1: 2, r_2: 1), envelope(omega_1: 1, omega_2: 11, r_1: 0, r_2: 3),
  // Part of the curve appears as a series of points because the parameter speed is high there, so only points are drawn without linear interpolation.
  rotate(90deg, reflow: true, envelope(omega_1: 5, omega_2: 3, r_1: 2.01, r_2: 2, geom-granularity: geom-presets.fine)),
)
