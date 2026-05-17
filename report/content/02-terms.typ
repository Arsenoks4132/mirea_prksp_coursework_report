#import "../const.typ"

#let terms-table(body) = {
  let items = body.children.filter(it => it.func() == terms.item)

  let get-text(content) = {
    if content.has("children") and content.children.len() > 0 {
      let first = content.children.at(0)
      if first.has("text") { return first.text }
    }
    if content.has("text") { return content.text }
    ""
  }

  let sorted = items.sorted(key: it => lower(get-text(it.term)))
  let rows = sorted.map(it => (it.term, [–#h(const.leading-one)#it.description]))

  set par(justify: true)

  table(
    columns: (1fr, 2fr),
    align: left + top,
    stroke: none,
    inset: 0mm,
    column-gutter: const.leading-one,
    row-gutter: const.leading-one-and-a-half,
    ..rows.flatten()
  )
}

#[
  #show heading: it => align(center, upper(it))
  #heading(numbering: none)[ОПРЕДЕЛЕНИЯ, ОБОЗНАЧЕНИЯ И СОКРАЩЕНИЯ]
]

В настоящем отчете применяют следующие определения, обозначения и сокращения.

#terms-table[
  / API (Application Programming Interface): программный интерфейс приложения, обеспечивающий взаимодействие между программными компонентами.
  / CRUD (Create, Read, Update, Delete): базовые операции создания, чтения, изменения и удаления данных.
  / CSS (Cascading Style Sheets): язык описания внешнего вида веб-страниц.
  / Django: высокоуровневый веб-фреймворк на языке Python, предназначенный для разработки серверной части веб-приложений.
  / Docker: программная платформа контейнеризации, используемая для упаковки и запуска приложений в изолированной среде.
  / HTML (HyperText Markup Language): язык разметки веб-страниц.
  / HTTP (HyperText Transfer Protocol): протокол передачи данных между клиентом и сервером.
  / MVT (Model-View-Template): архитектурный паттерн, используемый в Django и разделяющий приложение на модели данных, обработчики запросов и шаблоны отображения.
  / ORM (Object-Relational Mapping): технология отображения объектов языка программирования на таблицы реляционной базы данных.
  / PostgreSQL: объектно-реляционная система управления базами данных.
  / Redis: высокопроизводительное хранилище данных в памяти, применяемое в том числе для кеширования.
  / SQL (Structured Query Language): язык запросов к реляционным базам данных.
  / URL (Uniform Resource Locator): унифицированный указатель адреса ресурса в сети.
  / СУБД: система управления базами данных.
  / Фреймворк: программный каркас, задающий базовую структуру и инструменты разработки программного обеспечения.
]
