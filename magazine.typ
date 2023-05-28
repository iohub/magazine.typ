
#let buildMainHeader(mainHeadingContent) = {
  [
    #align(center, smallcaps(mainHeadingContent)) 
    #line(length: 100%)
  ]
}

#let buildGenHeader(head) = {
  [
    #stack(
        dir: ttb,
        rect(fill: rgb("#17064f"), radius: (top-right: 5pt), stroke: rgb("#17064f"))[
          #strong(
            text(white)[
              #head
            ]
          )
        ]
    )
  ]
}

#let buildSecondaryHeader(mainHeadingContent, secondaryHeadingContent) = {
  [
    #align(left,
    stack(
        dir: ttb,
        rect(fill: rgb("#17064f"), radius: (top-right: 5pt), stroke: rgb("#17064f"))[
          #strong(
            text(white, 16pt)[
              #mainHeadingContent
            ]
          )
          #text(white, 13pt)[
              #secondaryHeadingContent
          ]
        ]
    ))
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
    // return buildGenHeader([技术月刊])
    return buildSecondaryHeader([技术洞察月刊], [第1期 2023年5月])
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
      // return
      return buildSecondaryHeader(lastMainHeading.body, lastSecondaryHeading.body)
    }
    return buildMainHeader(lastMainHeading.body)
  })
}


#let base_env(type: "Theorem", name: none, numbered: true, fg: black, bg: white, title: true,
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


#let block_env(type: "Theorem", name: none, numbered: true, fg: black, bg: white, title: true,
          body) = locate(
    location => {
      let lvl = counter(heading).at(location)
      let i = counter(type).at(location).first()
      let top = if lvl.len() > 0 { lvl.first() } else { 0 }
      show: block.with(spacing: 11.5pt)
      stack(
        dir: ttb,
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

#let corollary = block_env.with(
  type: "信息速递",
  fg: rgb("#093bba"),
  bg: rgb("#e8e8f8"),
)

#let gossip = block_env.with(
  type: "行业八卦",
  fg: rgb("#6922ab"),
  bg: rgb("#e8e8f8"),
)

// Title
#set page(background: image("bg2.jpg"), margin: (x: 0pt, bottom: 0pt))
#set align(center)
#text(font: "STZHONGS.TTF", weight: 800, [技术月刊], size: 68pt, fill: rgb("#014482"))
#pagebreak()

// Table of contents.
#set align(center)
#set page(background: none, margin: auto)
#outline(title: [目录], depth: 1, indent: true)
#pagebreak()


// main body
#set page(header: getHeader(), numbering: "1 / 1")
#set align(center)
= 文章一
#set align(right)
Bob & Bert 架构设计部
#set align(left)
\ 
== 子标题2
#columns(2, [#lorem(200)
  内容填充 
  #theorem[
    [1] Jimmy Lei Ba, Jamie Ryan Kiros, and Geoffrey E Hinton. Layer normalization. arXiv preprint
arXiv:1607.06450, 2016. \
    [2] Dzmitry Bahdanau, Kyunghyun Cho, and Yoshua Bengio. Neural machine translation by jointly
learning to align and translate. CoRR, abs/1409.0473, 2014. \
    [3] Denny Britz, Anna Goldie, Minh-Thang Luong, and Quoc V. Le. Massive exploration of neural
machine translation architectures. CoRR, abs/1703.03906, 2017.


  ]]
)

#pagebreak(weak: true)


// Shared Page

#set align(center)
// #text(font: "STZHONGS.TTF", weight: 800, [信息速递], size: 28pt, fill: rgb("#014482"))
= 信息速递
\
#set align(left)
#columns(2, [
  #corollary[
    [1] Jimmy Lei Ba, Jamie Ryan Kiros, and Geoffrey E Hinton. Layer normalization. arXiv preprint
arXiv:1607.06450, 2016. 
  ]
  #corollary[
    [1] Jimmy Lei Ba, Jamie Ryan Kiros, and Geoffrey E Hinton. Layer normalization. arXiv preprint
arXiv:1607.06450, 2016. 
  ]
  #corollary[
    [1] Jimmy Lei Ba, Jamie Ryan Kiros, and Geoffrey E Hinton. Layer normalization. arXiv preprint
arXiv:1607.06450, 2016. 
  ]
])
#pagebreak(weak: true)



// Gossip Page

#set align(center)
= 行业八卦
\
// #text(font: "STZHONGS.TTF", weight: 800, [行业八卦], size: 28pt, fill: rgb("#014482"))
#set align(left)
#columns(2, [
  #gossip[
    #link("https://baidu.com")[Jimmy Lei Ba, Jamie Ryan Kiros, and Geoffrey E Hinton. Layer normalization. arXiv preprint
arXiv:1607.06450, 2016.]
  ]

  #gossip[
    #link("https://so.com")[Jimmy Lei Ba, Jamie Ryan Kiros, and Geoffrey E Hinton. Layer normalization. arXiv preprint
arXiv:1607.06450, 2016.]
  ]


])
#pagebreak(weak: true)
