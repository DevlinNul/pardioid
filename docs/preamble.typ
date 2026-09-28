#let start-prefix = "#start "
#let end-prefix = "#end "
#let path-prefix = "../src/"

#let extract-region(src, start-marker, end-marker) = {
  let lines = src.split("\n")
  let i = lines.position(l => l.trim("//").trim() == start-marker)
  let j = lines.position(l => l.trim("//").trim() == end-marker)
  lines.slice(i + 1, j).join("\n")
}

#let extract-def(path, id: str, path-prefix: path-prefix) = {
  let src = read(path-prefix + path)
  let start-marker = start-prefix + id
  let end-marker = end-prefix + id
  raw(extract-region(src, start-marker, end-marker), lang: "typ", block: true)
}

#let extract-doc(path, id: str, path-prefix: path-prefix) = {
  let src = read(path-prefix + path)
  let start-marker = start-prefix + id
  let end-marker = end-prefix + id
  let body = extract-region(src, start-marker, end-marker)
  let doc-lines = body
    .split("\n")
    .map(
      line => if line == "" { "///" } else { "/// " + line },
    )
    .join("\n")
  doc-lines
}



#let macros = (
  "ret": (
    handler: id => extract-doc(id: id, std.path("type-annotation.typ"), path-prefix: none),
    description: "",
  ),
)

#let macro-pattern = regex("^\s*///\s*#([a-z][a-z0-9-]*)\s+([A-Za-z0-9_.-]+)\s*$")

#let expand-macros(src) = {
  src
    .split("\n")
    .map(line => {
      let m = line.match(macro-pattern)
      if m == none { return line }
      let kind = m.captures.at(0)
      let id = m.captures.at(1)
      if kind not in macros { return line }
      (macros.at(kind).handler)(id)
    })
    .join("\n")
}
