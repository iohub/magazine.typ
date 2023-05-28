
#let buildMainHeader(mainHeadingContent) = {
  [
    #align(center, smallcaps(mainHeadingContent)) 
    #line(length: 100%)
  ]
}

#let buildSecondaryHeader(mainHeadingContent, secondaryHeadingContent) = {
  [
    #smallcaps(mainHeadingContent)  #h(1fr)  #emph(secondaryHeadingContent) 
    #line(length: 100%)
  ]
}

// To know if the secondary heading appears after the main heading
#let isAfter(secondaryHeading, mainHeading) = {
  let secHeadPos = secondaryHeading.location().position()
  let mainHeadPos = mainHeading.location().position()
  if (secHeadPos.at("page") > mainHeadPos.at("page")) {
    return true
  }
  if (secHeadPos.at("page") == mainHeadPos.at("page")) {
    return secHeadPos.at("y") > mainHeadPos.at("y")
  }
  return false
}

#let getHeader() = {
  locate(loc => {
    // Find if there is a level 1 heading on the current page
    let nextMainHeading = query(selector(heading).after(loc), loc).find(headIt => {
     headIt.location().page() == loc.page() and headIt.level == 1
    })
    if (nextMainHeading != none) {
      return buildMainHeader(nextMainHeading.body)
    }
    // Find the last previous level 1 heading -- at this point surely there's one :-)
    let lastMainHeading = query(selector(heading).before(loc), loc).filter(headIt => {
      headIt.level == 1
    }).last()
    // Find if the last level > 1 heading in previous pages
    let previousSecondaryHeadingArray = query(selector(heading).before(loc), loc).filter(headIt => {
      headIt.level > 1
    })
    let lastSecondaryHeading = if (previousSecondaryHeadingArray.len() != 0) {previousSecondaryHeadingArray.last()} else {none}
    // Find if the last secondary heading exists and if it's after the last main heading
    if (lastSecondaryHeading != none and isAfter(lastSecondaryHeading, lastMainHeading)) {
      return buildSecondaryHeader(lastMainHeading.body, lastSecondaryHeading.body)
    }
    return buildMainHeader(lastMainHeading.body)
  })
}


#let base_env(type: "Theorem", name: none, numbered: true, fg: black, bg: white,
          body) = locate(
    location => {
      let lvl = counter(heading).at(location)
      let i = counter(type).at(location).first()
      let top = if lvl.len() > 0 { lvl.first() } else { 0 }
      show: block.with(spacing: 11.5pt)
      stack(
        dir: ttb,
        rect(fill: fg, radius: (top-right: 5pt), stroke: fg)[
          #strong(
            text(white)[
              #type
              #if name != none [ (#name) ]
            ]
          )
        ],
        rect(width: 100%,
          fill: bg,
          radius: ( right: 5pt ),
          stroke: (
            left: fg,
            right: bg + 0pt,
            top: bg + 0pt,
            bottom: bg + 0pt,
          )
        )[
          #emph(body)
        ]
      )
    }
)

#let theorem = base_env.with(
  type: "参考文献",
  fg: blue,
  bg: rgb("#e8e8f8"),
)

#set align(center)
// #text(0.85em, smallcaps[Abstract])
#set page(background: image("bg2.jpg"), margin: (x: 0pt, bottom: 0pt))


#pagebreak()

#set align(center)
#set page(background: none, margin: auto)
// Table of contents.
#outline(depth: 3, indent: true)
#pagebreak()

#set page(numbering: "1 / 1")

#set align(center)
= 文章一
#set align(left)
== 子标题1
#lorem(200)
\ \ \
== 子标题2
#columns(2, [#lorem(200)
  内容填充
  #theorem[
    #lorem(20)
  ]]
)

#pagebreak(weak: true)




#set align(center)
= 文章2
#set align(left)
== 子标题3
#lorem(80)
\ \ \

#columns(2, [#lorem(500)])
#pagebreak(weak: true)
