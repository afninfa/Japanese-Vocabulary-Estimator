import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import types.{type Msg, type Theme, Dark, Light}

pub type Colour =
  String

pub const white = "#ffffff"

pub const green = "#22c55e"

pub const blue = "#3b82f6"

pub const red = "#ef4444"

pub const light_grey = "#9cafc9ff"

pub const dark_grey = "#1e293b"

pub const black = "#000000"

pub fn text_colour(theme) {
  case theme {
    Light -> black
    Dark -> white
  }
}

pub fn background_colour(theme) {
  case theme {
    Light -> light_grey
    Dark -> dark_grey
  }
}

pub fn stack(theme: Theme, children: List(Element(Msg))) -> Element(Msg) {
  html.div(
    [
      attribute.style("position", "fixed"),
      attribute.style("top", "0"),
      attribute.style("left", "0"),
      attribute.style("display", "flex"),
      attribute.style("flex-direction", "column"),
      attribute.style("align-items", "center"),
      attribute.style("justify-content", "center"),
      attribute.style("gap", "1.5rem"),
      attribute.style("height", "100vh"),
      attribute.style("width", "100%"),
      attribute.style("background-color", background_colour(theme)),
      attribute.style("transition", "background-color 0.3s ease"),
    ],
    children,
  )
}

pub fn row(children: List(Element(Msg))) -> Element(Msg) {
  html.div(
    [
      attribute.style("display", "flex"),
      attribute.style("flex-direction", "row"),
      attribute.style("align-items", "center"),
      attribute.style("gap", "1rem"),
    ],
    children,
  )
}

pub fn button(label: String, colour: Colour, msg: Msg) -> Element(Msg) {
  html.button(
    [
      event.on_click(msg),
      attribute.style("background-color", colour),
      attribute.style("color", "white"),
      attribute.style("padding", "0.75rem 1.5rem"),
      attribute.style("border-radius", "8px"),
      attribute.style("border", "none"),
      attribute.style("font-weight", "bold"),
      attribute.style("cursor", "pointer"),
      attribute.style("font-size", "1.2rem"),
    ],
    [html.text(label)],
  )
}

pub fn text(theme: Theme, content: String) -> Element(Msg) {
  html.p(
    [
      attribute.style("font-size", "2.5rem"),
      attribute.style("font-weight", "600"),
      attribute.style("margin", "0"),
      attribute.style("color", text_colour(theme)),
    ],
    [html.text(content)],
  )
}

pub fn label(content: String, colour: Colour) -> Element(Msg) {
  html.span(
    [
      attribute.style("color", colour),
      attribute.style("font-weight", "500"),
    ],
    [html.text(content)],
  )
}

pub fn options_bar(children: List(Element(Msg))) -> Element(Msg) {
  html.div(
    [
      attribute.style("position", "absolute"),
      attribute.style("top", "1.5rem"),
      attribute.style("right", "1.5rem"),
      attribute.style("display", "flex"),
      attribute.style("flex-direction", "row-reverse"),
      attribute.style("gap", "1rem"),
      attribute.style("align-items", "start"),
    ],
    children,
  )
}
