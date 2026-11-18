#let template = (
  einleitung: [],

  titel: "Teilnahmebestätigung",
  veranstaltung: "Strategie Offsite",
  untertitel: "",

  teilnahme: [],

  beschreibung: [],

  liste: (
    titel: "",
    text: []
  ),

  ort: [München, den 18.11.2026],
  unterschrift: (
    name: "Phil Scholz",
    funktion: "Media Lab Bayern",
  ),
)

// Page Setup
#set page(
  paper: "a4",
  margin: (x: 5mm, y: 5mm),
)

// Farben
#let mlb-turquoise = rgb("#007083")
#let mlb-marin = rgb("#04313E")
#let mlb-marin-50 = mlb-marin.lighten(50%)
#let rahmen-farbe = mlb-turquoise.lighten(20%)
#let name-farbe = mlb-marin

// Assets
#let logo = "../../assets/MLB_Logo_2 lines-Brand-RGB.svg"

// Typography
#let sans-fonts = ("IBM Plex Sans",)   // trailing comma makes it a real array
#let heading-fonts = ("PP Formula",)

// Helper: Formula text with special styling
#let formula(size, weight: "regular", body) = text(
  font: heading-fonts, weight: weight, size: size, features: ("ss02", "ss03"), hyphenate: false, body,
)
#let bescheinigung(vorname: "", nachname: "", template: (:)) = {
  let name = vorname + " " + nachname
  set text(font: sans-fonts, fill: mlb-marin, lang: "de")
  set par(leading: 0.6em, spacing: 0.9em)
  set list(indent: 0.4em, body-indent: 0.8em, spacing: 0.45em)

  set document(title: template.titel + "  " + name + " – Media Lab Bayern")
  
  // Header
  grid(
    columns: (1fr, 3fr),
    rows: 1,
    gutter: 0.5fr,
    image(logo),
    text(size: 9pt, fill: mlb-marin-50, hyphenate: true,
    "Das Media Lab Bayern ist ein durch die Bayerische Staatskanzlei und die Bayerische Landeszentrale für neue Medien (BLM) geförderter Innovations-Hub für Medien und digitalen Journalismus. An unseren beiden Standorten in München und Ansbach unterstützen wir Entrepreneure, Journalist:innen, Startups und junge Talente darin, neue Ideen zu entwickeln und eigene innovative Projekte voranzutreiben."
    )
  )
  v(5mm)

  // Titelblock
  v(9mm)
  align(left, {
    set par(leading: 1.5em, spacing: 1em)
    formula(40pt, text(fill: mlb-marin, template.at("titel", default: "")))
    linebreak()
    formula(40pt, template.at("veranstaltung", default: ""))
    linebreak()
    if template.at("event-subtitle", default: none) != none {
      v(-1mm)
      formula(40pt, template.at("event-subtitle"))
    }
  })
  
  // Name mit Linie
  v(5mm)
  grid(
    columns: (1fr, 3fr),
    rows: 1,
    gutter: 0.5fr,
    "",
    {
      set text(lang: "de", hyphenate: true)
      formula(40pt, weight: "regular", name)
      linebreak()
      v(5mm)
    }
  )
  grid(
    columns: (1fr, 3fr),
    rows: 1,
    gutter: 0.5fr,
    "",
    {
      if template.at("teilnahme", default: none) != none {
        text(fill: mlb-marin, template.teilnahme)
        linebreak()
        v(2mm)
      }
      if template.at("beschreibung", default: none) != none {
        text(fill: mlb-marin, template.beschreibung)
      }
      if template.at("liste", default: none) != none {
        v(2mm)
        text(weight: "bold", fill: mlb-marin, template.liste.titel + ":")
        v(1mm)
        set list(indent: 0.4em, body-indent: 0.8em, spacing: 0.45em)
        text(fill: mlb-marin, template.liste.text)
      }
      // Ort, Datum, Unterschrift
  v(1fr)
  if template.at("ort", default: "München") != none {
    let date = template.at("datum", default: datetime.today().display("[day].[month].[year]"))
    text(fill: mlb-marin-50, template.ort + ", den " + date)
  }
  v(12mm)
  line(length: 100mm, stroke: 0.5pt + black)
  text(weight: "bold", template.unterschrift.name + ", " + template.unterschrift.funktion + " im Media Lab Bayern")
      }
  )
  pagebreak(weak:true)
}
