#import "template/vendor/medialab-bescheinigung.typ": bescheinigung

#let template = (
  titel: "Teilnahmebestätigung",
  veranstaltung: "Strategie Offsite",
  untertitel: none,
  
  einleitung: [Das Media Lab Bayern ist ein durch die Bayerische Staatskanzlei und die Bayerische Landeszentrale für neue Medien (BLM) geförderter Innovations-Hub für Medien und digitalen Journalismus. An unseren beiden Standorten in München und Ansbach unterstützen wir Entrepreneure, Journalist:innen, Startups und junge Talente darin, neue Ideen zu entwickeln und eigene innovative Projekte voranzutreiben.],
  
  teilnahme: [hat vom 16. bis 18.11.2026 am Strategie Offsite in Würzburg teilgenommen.],
  
  beschreibung: [Das Strategie Offsite ist ein Format des Media Lab Bayern, in dem Young Professionals mit Medienfokus gemeinsam mit erfahrenen Branchen-Expert:innen an realen strategischen Herausforderungen von Medienhäusern arbeiten. 
  
  Die Teilnahme umfasste ein virtuelles Kennenlernen sowie ein dreitägiges Intensiv-Offsite, in dem erprobte Strategie-Frameworks vermittelt und direkt angewendet wurden. Sie belegt die Fähigkeit, komplexe Fragestellungen strukturiert zu analysieren, unterschiedliche Perspektiven einzubeziehen und daraus tragfähige strategische Ansätze zu entwickeln.],
  
  schlüsselfakten: (
    "Dauer": [19 Stunden],
  ),
  
  liste: (
    titel: "Thematische Schwerpunkte",
    text: [
      - Stakeholder-Analyse: Betroffene, Ziele, Erfolgsmessung und Werte
      - Zielbild: Zieldefinition, Nutzen für Stakeholder und Hinderungsgründe
      - Experten-Interviews und Transfer von Best Practices
      - Strategieentwicklung: Umsetzungsschritte, Artefakte und Erfolgskriterien
      - Peer-Feedback und Reflexion
    ]
  ),
  
  ort: [München],
  datum: [18.11.2026],
  
  unterschrift: (
    name: "Phil Scholz",
    funktion: "Projektmanager",
  ),
)


#let datei = "teilnehmende.csv"


#let roh = read(datei)
#let kopf = roh.split("\n").first()
#let trenner = if kopf.contains(";") { ";" } else if kopf.contains("\t") { "\t" } else { "," }
#let zeilen = csv(datei, delimiter: trenner)
#let spalten = zeilen.first().map(k => lower(k.trim("\u{feff}").trim()))
#let i-vor = spalten.position(k => k == "vorname")
#let i-nach = spalten.position(k => k == "nachname")

#let personen = if i-vor == none or i-nach == none { () } else {
  zeilen.slice(1)
    .filter(z => z.len() > calc.max(i-vor, i-nach))
    .map(z => (Vorname: z.at(i-vor).trim(), Nachname: z.at(i-nach).trim()))
    .filter(p => p.Vorname != "" or p.Nachname != "")
}

#let auswahl = if "nr" in sys.inputs {
  (personen.at(int(sys.inputs.nr) - 1),)
} else { personen }

#if personen.len() == 0 {
  set text(fill: red, size: 14pt)
  [*Keine Teilnehmenden gefunden.* \
  Erwartet werden die Spalten „Vorname“ und „Nachname“. \
  Gefundene Spalten: #zeilen.first().join(" | ") \
  Erkanntes Trennzeichen: "#trenner"]
}
#for p in auswahl {
  bescheinigung(vorname: p.Vorname, nachname: p.Nachname, template: template)
}
