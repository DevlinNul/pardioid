// 本模块翻译数据（抽离自 locales.typ）
#let local-names-data = (
  "sq": (parameters: [Parametrat], default: [Standard], variables: [Variablat]),
  "ar": (parameters: [المعلمات], default: [الافتراضي], variables: [المتغيرات]),
  "eu": (parameters: [Parametroak], default: [Lehenetsia], variables: [Aldagaiak]),
  "nb": (parameters: [Parametere], default: [Standard], variables: [Variabler]),
  "bg": (parameters: [Параметри], default: [По подразбиране], variables: [Променливи]),
  "ca": (parameters: [Paràmetres], default: [Per defecte], variables: [Variables]),
  "zh": (parameters: [参数], default: [默认值], variables: [变量]),
  "hr": (parameters: [Parametri], default: [Zadano], variables: [Varijable]),
  "cs": (parameters: [Parametry], default: [Výchozí], variables: [Proměnné]),
  "da": (parameters: [Parametre], default: [Standard], variables: [Variabler]),
  "nl": (parameters: [Parameters], default: [Standaard], variables: [Variabelen]),
  "en": (parameters: [Parameters], default: [Default], variables: [Variables]),
  "et": (parameters: [Parameetrid], default: [Vaikimisi], variables: [Muujad]),
  "tl": (parameters: [Mga Parameter], default: [Karaniwan], variables: [Mga Variable]),
  "fi": (parameters: [Parametrit], default: [Oletus], variables: [Muuttujat]),
  "fr": (parameters: [Paramètres], default: [Par défaut], variables: [Variables]),
  "gl": (parameters: [Parámetros], default: [Por defecto], variables: [Variables]),
  "de": (parameters: [Parameter], default: [Standard], variables: [Variablen]),
  "el": (parameters: [Παράμετροι], default: [Προεπιλογή], variables: [Μεταβλητές]),
  "he": (parameters: [פרמטרים], default: [ברירת מחדל], variables: [משתנים]),
  "hu": (parameters: [Paraméterek], default: [Alapértelmezett], variables: [Változók]),
  "is": (parameters: [Færibreytur], default: [Sjálfgefið], variables: [Breytur]),
  "id": (parameters: [Parameter], default: [Baku], variables: [Variabel]),
  "it": (parameters: [Parametri], default: [Predefinito], variables: [Variabili]),
  "ja": (parameters: [パラメーター], default: [デフォルト], variables: [変数]),
  "la": (parameters: [Parametri], default: [Definitum], variables: [Variabilia]),
  "dsb": (parameters: [Parametry], default: [Standard], variables: [Wariable]),
  "nn": (parameters: [Parametrar], default: [Standard], variables: [Variablar]),
  "pl": (parameters: [Parametry], default: [Domyślne], variables: [Zmienne]),
  "pt": (parameters: [Parâmetros], default: [Padrão], variables: [Variáveis]),
  "ro": (parameters: [Parametri], default: [Implicit], variables: [Variabile]),
  "ru": (parameters: [Параметры], default: [По умолчанию], variables: [Переменные]),
  "sr": (parameters: [Параметри], default: [Подразумевано], variables: [Променљиве]),
  "sk": (parameters: [Parametre], default: [Predvolené], variables: [Premenné]),
  "sl": (parameters: [Parametri], default: [Privzeto], variables: [Spremenljivke]),
  "es": (parameters: [Parámetros], default: [Por defecto], variables: [Variables]),
  "sv": (parameters: [Parametrar], default: [Standard], variables: [Variabler]),
  "tr": (parameters: [Parametreler], default: [Varsayılan], variables: [Değişkenler]),
  "uk": (parameters: [Параметри], default: [За замовчуванням], variables: [Змінні]),
  "vi": (parameters: [Tham số], default: [Mặc định], variables: [Biến số]),
)

// 辅助工具函数（抽离自 utilities.typ）
#let get-local-name(target, style-args: (:)) = context {
  if target in style-args.local-names {
    return style-args.local-names.at(target)
  }
  let language = text.lang
  if language not in local-names-data.keys() {
    panic("Unknown language '" + language + "', you can use custom translations with `#show-module(local-names: ...)`")
  }
  return local-names-data.at(text.lang).at(target)
}

#let reference-matcher = regex(`@@([\w\d\-_\)\(]+)`.text)

#let process-references(text-content, info) = {
  return text-content.replace(reference-matcher, match => {
    let target = match.captures.at(0)
    if info.enable-cross-references {
      return "#(tidy.show-reference)(label(\"" + info.label-prefix + target + "\"), \"" + target + "\")"
    } else {
      return target
    }
  })
}

#let eval-docstring(docstring, info) = {
  let scope = info.scope
  let content = process-references(docstring.trim(), info)
  eval(content, mode: "markup", scope: scope)
}

// 示例布局与渲染函数（抽离自 show-example.typ）
#let default-layout-example(
  code,
  preview,
  dir: ltr,
  ratio: 1,
  scale-preview: auto,
  code-block: block,
  preview-block: block,
  col-spacing: 5pt,
) = {
  let preview-outer-padding = 5pt
  let preview-inner-padding = 5pt

  layout(size => context {
    let code-width
    let preview-width

    if dir.axis() == "vertical" {
      code-width = size.width
      preview-width = size.width
    } else {
      code-width = ratio / (ratio + 1) * size.width - 0.5 * col-spacing
      preview-width = size.width - code-width - col-spacing
    }

    let available-preview-width = preview-width - 2 * (preview-outer-padding + preview-inner-padding)

    let preview-size
    let scale-preview = scale-preview

    if scale-preview == auto {
      preview-size = measure(preview)
      assert(
        preview-size.width != 0pt,
        message: "The code example has a relative width. Please set `scale-preview` to a fixed ratio, e.g., `100%`",
      )
      scale-preview = calc.min(1, available-preview-width / preview-size.width) * 100%
    } else {
      preview-size = measure(block(preview, width: available-preview-width / (scale-preview / 100%)))
    }

    set par(hanging-indent: 0pt)

    let arrangement(width: 100%, height: auto) = block(width: width, inset: 0pt, stack(
      dir: dir,
      spacing: col-spacing,
      code-block(
        width: code-width,
        height: height,
        inset: 5pt,
        {
          set text(size: .9em)
          set raw(block: true)
          code
        },
      ),
      preview-block(
        height: height,
        width: preview-width,
        inset: preview-outer-padding,
        box(
          width: 100%,
          height: if height == auto { auto } else { height - 2 * preview-outer-padding },
          fill: white,
          inset: preview-inner-padding,
          box(
            inset: 0pt,
            width: preview-size.width * (scale-preview / 100%),
            height: preview-size.height * (scale-preview / 100%),
            place(scale(
              scale-preview,
              origin: top + left,
              block(preview, height: preview-size.height, width: preview-size.width),
            )),
          ),
        ),
      ),
    ))
    let height = if dir.axis() == "vertical" { auto } else { measure(arrangement(width: size.width)).height }
    arrangement(height: height)
  })
}

#let internal-show-example(
  code,
  scope: (:),
  preamble: "",
  mode: auto,
  inherited-scope: (:),
  layout: default-layout-example,
  ..options,
) = {
  let displayed-code = code
    .text
    .split("\n")
    .filter(x => not x.starts-with(">>>"))
    .map(x => x.trim("<<<", at: start))
    .join("\n")
  let executed-code = code
    .text
    .split("\n")
    .filter(x => not x.starts-with("<<<"))
    .map(x => x.trim(">>>", at: start))
    .join("\n")

  let lang = if code.has("lang") { code.lang } else { auto }
  if mode == auto {
    if lang == "typ" { mode = "markup" } else if lang == "typc" { mode = "code" } else if lang == "typm" {
      mode = "math"
    } else if lang == auto { mode = "markup" }
  }
  if lang == auto {
    if mode == "markup" { lang = "typ" }
    if mode == "code" { lang = "typc" }
    if mode == "math" { lang = "typm" }
  }
  if mode == "code" {
    preamble = ""
  }
  assert(
    lang in ("typ", "typc", "typm"),
    message: "Previewing code only supports the languages \"typ\", \"typc\", and \"typm\"",
  )

  layout(
    raw(displayed-code, lang: lang, block: true),
    [#eval(preamble + executed-code, mode: mode, scope: scope + inherited-scope)],
    ..options,
  )
}

// 基础变量与样式定义
#let function-name-color = rgb("#4b69c6")
#let rainbow-map = ((rgb("#7cd5ff"), 0%), (rgb("#a6fbca"), 33%), (rgb("#fff37c"), 66%), (rgb("#ffa49d"), 100%))
#let gradient-for-color-types = gradient.linear(angle: 7deg, ..rainbow-map)
#let gradient-for-tiling = gradient.linear(angle: -45deg, rgb("#ffd2ec"), rgb("#c6feff")).sharp(2).repeat(5)

#let default-type-color = rgb("#eff0f3")

#let colors = (
  "default": default-type-color,
  "content": rgb("#a6ebe6"),
  "string": rgb("#d1ffe2"),
  "str": rgb("#d1ffe2"),
  "none": rgb("#ffcbc4"),
  "auto": rgb("#ffcbc4"),
  "bool": rgb("#9fedc1"),
  "boolean": rgb("#ffedc1"),
  "integer": rgb("#e7d9ff"),
  "int": rgb("#e7d9ff"),
  "decimal": rgb("#e7d9ff"),
  "float": rgb("#e7d9ff"),
  "ratio": rgb("#e7d9ff"),
  "length": rgb("#ffecbf"),
  "angle": rgb("#e7d9ff"),
  "relative length": rgb("#e7d9ff"),
  "relative": rgb("#e7d9ff"),
  "fraction": rgb("#e7d9ff"),
  "symbol": default-type-color,
  "array": rgb("#a3e57b"),
  "dictionary": rgb("#70ebed"),
  "arguments": default-type-color,
  "selector": default-type-color,
  "module": default-type-color,
  "stroke": gradient-for-color-types,
  "function": rgb("#f9dfff"),
  "color": gradient-for-color-types,
  "gradient": gradient-for-color-types,
  "tiling": gradient-for-tiling,
  "signature-func-name": rgb("#4b69c6"),
)

#let colors-dark = {
  let k = (:)
  let darkify(clr) = clr.darken(30%).saturate(30%)
  for (key, value) in colors {
    if type(value) == color {
      value = darkify(value)
    } else if type(value) == gradient {
      let map = value.stops().map(((clr, stop)) => (darkify(clr), calc.round(stop / 1%) * 1%))
      value = value.kind()(..map)
    }
    k.insert(key, value)
  }
  k.signature-func-name = rgb("#4b69c6").lighten(40%)
  k
}

#let show-outline(module-doc, style-args: (:)) = {
  let prefix = module-doc.label-prefix
  let gen-entry(name) = {
    if "enable-cross-references" in style-args and style-args.enable-cross-references {
      link(label(prefix + name), name)
    } else {
      name
    }
  }
  if module-doc.functions.len() > 0 {
    list(..module-doc.functions.map(fn => gen-entry(fn.name + "()")))
  }

  if module-doc.variables.len() > 0 {
    text(get-local-name("variables", style-args: style-args), weight: "bold")
    list(..module-doc.variables.map(var => gen-entry(var.name)))
  }
}

#let show-type(type, style-args: (:)) = {
  h(2pt)
  let clr = style-args.colors.at(type, default: style-args.colors.at("default", default: default-type-color))
  box(outset: 2pt, fill: clr, radius: 2pt, raw(type, lang: none))
  h(2pt)
}

#let show-parameter-list(fn, style-args: (:)) = {
  pad(x: 10pt, {
    set text(font: "DejaVu Sans Mono", size: 0.85em, weight: 340)
    text(fn.name, fill: style-args.colors.at("signature-func-name", default: rgb("#4b69c6")))
    "("
    let inline-args = fn.args.len() < 2
    if not inline-args { "\n  " }
    let items = ()
    for (name, info) in fn.args {
      if style-args.omit-private-parameters and name.starts-with("_") {
        continue
      }
      let types
      if "types" in info {
        types = ": " + info.types.map(x => show-type(x, style-args: style-args)).join(" ")
      }
      if (
        style-args.enable-cross-references
          and not (info.at("description", default: "") == "" and style-args.omit-empty-param-descriptions)
      ) {
        name = link(label(style-args.label-prefix + fn.name + "." + name.trim(".")), name)
      }
      items.push(name + types)
    }
    items.join(if inline-args { ", " } else { ",\n  " })
    if not inline-args { "\n" } + ")"
    if "return-types" in fn and fn.return-types != none {
      " -> "
      fn.return-types.map(x => show-type(x, style-args: style-args)).join(" ")
    }
  })
}

#let show-parameter-block(
  function-name: none,
  name,
  types,
  content,
  style-args,
  show-default: false,
  default: none,
) = block(
  inset: 10pt,
  fill: rgb("ddd3"),
  width: 100%,
  breakable: style-args.break-param-descriptions,
  [
    #box(heading(level: style-args.first-heading-level + 3, name))
    #if function-name != none and style-args.enable-cross-references { label(function-name + "." + name.trim(".")) }
    #h(1.2em)
    #types.map(x => (style-args.style.show-type)(x, style-args: style-args)).join([ #text("or", size: .6em) ])

    #content
    #if show-default [
      #parbreak()
      #get-local-name("default", style-args: style-args): #raw(lang: "typc", default)
    ]
  ],
)

#let show-function(
  fn,
  style-args,
) = {
  if style-args.colors == auto { style-args.colors = colors }

  [
    #heading(fn.name, level: style-args.first-heading-level + 1)
    #if style-args.enable-cross-references {
      label(style-args.label-prefix + fn.name + "()")
    }
  ]

  eval-docstring(fn.description, style-args)

  block(breakable: style-args.break-param-descriptions, {
    heading(
      get-local-name("parameters", style-args: style-args),
      level: style-args.first-heading-level + 2,
    )
    (style-args.style.show-parameter-list)(fn, style-args: style-args)
  })

  for (name, info) in fn.args {
    if style-args.omit-private-parameters and name.starts-with("_") {
      continue
    }
    let types = info.at("types", default: ())
    let description = info.at("description", default: "")
    if description == "" and style-args.omit-empty-param-descriptions { continue }
    (style-args.style.show-parameter-block)(
      name,
      types,
      eval-docstring(description, style-args),
      style-args,
      show-default: "default" in info,
      default: info.at("default", default: none),
      function-name: style-args.label-prefix + fn.name,
    )
  }
  v(4.8em, weak: true)
}

#let show-variable(
  var,
  style-args,
) = {
  if style-args.colors == auto { style-args.colors = colors }
  let type = if "type" not in var { none } else { show-type(var.type, style-args: style-args) }

  stack(
    dir: ltr,
    spacing: 1.2em,
    if style-args.enable-cross-references [
      #heading(var.name, level: style-args.first-heading-level + 1)
      #label(style-args.label-prefix + var.name)
    ] else [
      #heading(var.name, level: style-args.first-heading-level + 1)
    ],
    type,
  )

  eval-docstring(var.description, style-args)
  v(4.8em, weak: true)
}

#let show-reference(label, name, style-args: none) = {
  link(label, raw(name, lang: none))
}

#let show-example(
  ..args,
) = {
  internal-show-example(
    ..args,
    layout: default-layout-example.with(
      code-block: block.with(radius: 3pt, stroke: .5pt + luma(200)),
      preview-block: block.with(radius: 3pt, fill: rgb("#e4e5ea")),
      col-spacing: 5pt,
    ),
  )
}
