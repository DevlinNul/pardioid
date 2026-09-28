

/// How to #link("https://typst.app/docs/reference/visualize/stroke/")[stroke] a curve.
///
/// Typst's default stroke is:
/// #extract-def("style.typ", id: "default-stroke")
///
/// But in this package, it is common for `default-base-stroke` to be the default value for the `stroke` parameter. For more details on how to merge strokes, see also @stroke-config.
/// -> stroke
#let stroke

/// A dictionary containing exactly `stroke-mode` and `base-stroke`.
///
/// `stroke-mode` is either #highlight("merge") or #highlight("cover").
///
/// `base-stroke` is the underlying stroke used for merging when `stroke-mode` is #highlight("merge"). When `stroke-mode` is #highlight("cover"), `base-stroke` has no effect.
///
/// Here is how stroke merging works:
/// #block[
///   #set par(first-line-indent: (amount: 2em, all: true))
///   Stroke merging resolves `auto` across a hierarchy of stroke layers. The bottom layer is `default-stroke`, the middle layer is `base-stroke`, and the top layer is the `stroke` supplied by the caller.
///
///   For each stroke parameter, `auto` indicates that the value should be inherited from the next lower layer. This inheritance may cascade through multiple layers. A non-`auto` value is used as-is and terminates further fallback for that parameter.
///
///   Since `default-stroke` contains no `auto` values, the fully expanded stroke is guaranteed to contain no `auto` values.
/// ]
///
/// `default-stroke-config` is defined as:
/// #extract-def("style.typ", id: "default-stroke-config")
///
/// `default-base-stroke` is defined as:
/// #extract-def("style.typ", id: "default-base-stroke")
/// -> Stroke-config
#let stroke-config


/// How to fill the curve.
/// -> color
#let fill

/// See #link("https://typst.app/docs/reference/visualize/curve/#parameters-fill")[curve's fill-rule parameter].
/// -> str
#let fill-rule

// 注意参数方向
