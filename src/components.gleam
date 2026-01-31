import gleam/float
import gleam/int
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import types.{type Msg, type Theme, Dark, Light}

pub type Colour =
  String

pub const white = "#ffffff"

pub const green = "#22c55e"

pub const dark_green = "#228B22"

pub const blue = "#3b82f6"

pub const gold = "#fbbf24"

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

pub fn adaptive_green(theme) {
  case theme {
    Light -> dark_green
    Dark -> green
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

pub fn button(
  theme: Theme,
  label: String,
  colour: Colour,
  msg: Msg,
) -> Element(Msg) {
  html.button(
    [
      event.on_click(msg),
      attribute.style("background-color", colour),
      attribute.style("color", text_colour(theme)),
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
      attribute.style("font-weight", "500"),
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

pub fn fraction_box(
  theme: Theme,
  numerator: Int,
  denominator: Int,
  label_text: String,
  selected: Bool,
) -> Element(Msg) {
  let percentage = case denominator {
    0 -> 0.0
    _ -> int.to_float(numerator) /. int.to_float(denominator) *. 100.0
  }

  let fill_colour = case selected {
    True -> green
    False -> blue
  }

  let box_width = case selected {
    True -> "120px"
    False -> "100px"
  }

  let box_height = case selected {
    True -> "96px"
    False -> "80px"
  }

  let font_size = case selected {
    True -> "1.4rem"
    False -> "1.2rem"
  }

  let label_size = case selected {
    True -> "1.05rem"
    False -> "0.9rem"
  }

  html.div(
    [
      attribute.style("display", "flex"),
      attribute.style("flex-direction", "column"),
      attribute.style("align-items", "center"),
      attribute.style("gap", "0.5rem"),
      attribute.style("min-width", box_width),
      attribute.style("transition", "all 0.3s ease"),
    ],
    [
      // Label text above
      html.span(
        [
          attribute.style("font-size", label_size),
          attribute.style("color", text_colour(theme)),
          attribute.style("font-weight", "500"),
          attribute.style("transition", "font-size 0.3s ease"),
        ],
        [html.text(label_text)],
      ),
      // The box with fill visualization
      html.div(
        [
          attribute.style("position", "relative"),
          attribute.style("width", box_width),
          attribute.style("height", box_height),
          attribute.style("border-radius", "12px"),
          attribute.style("border", "2px solid " <> text_colour(theme)),
          attribute.style("overflow", "hidden"),
          attribute.style("transition", "all 0.3s ease"),
        ],
        [
          // Filled portion
          html.div(
            [
              attribute.style("position", "absolute"),
              attribute.style("bottom", "0"),
              attribute.style("left", "0"),
              attribute.style("width", "100%"),
              attribute.style("height", float.to_string(percentage) <> "%"),
              attribute.style("background-color", fill_colour),
              attribute.style(
                "transition",
                "height 0.3s ease, background-color 0.3s ease",
              ),
            ],
            [],
          ),
          // Fraction text centered
          html.div(
            [
              attribute.style("position", "absolute"),
              attribute.style("top", "50%"),
              attribute.style("left", "50%"),
              attribute.style("transform", "translate(-50%, -50%)"),
              attribute.style("font-size", font_size),
              attribute.style("font-weight", "bold"),
              attribute.style("color", text_colour(theme)),
              attribute.style("z-index", "1"),
              attribute.style("transition", "font-size 0.3s ease"),
            ],
            [
              html.text(
                int.to_string(numerator) <> "/" <> int.to_string(denominator),
              ),
            ],
          ),
        ],
      ),
      // Selection marker underneath
      html.div(
        [
          attribute.style("width", "60%"),
          attribute.style("height", "4px"),
          attribute.style("border-radius", "2px"),
          attribute.style("background-color", case selected {
            True -> text_colour(theme)
            False -> "transparent"
          }),
          attribute.style("transition", "background-color 0.3s ease"),
        ],
        [],
      ),
    ],
  )
}
