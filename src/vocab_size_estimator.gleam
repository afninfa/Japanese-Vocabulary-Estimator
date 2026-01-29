import components as ui
import gleam/int
import lustre
import lustre/element.{type Element}
import types.{type Model, type Msg} as t

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    t.UserClickedIncrement -> model + 1
    t.UserClickedDecrement -> model - 1
  }
}

fn init(_args) -> Model {
  0
}

fn view(model: Model) -> Element(Msg) {
  let counter_repr = int.to_string(model)

  ui.stack([
    ui.row([
      ui.button("+", ui.green, t.UserClickedIncrement),
      ui.text(counter_repr),
      ui.button("-", ui.red, t.UserClickedDecrement),
    ]),

    ui.row([
      ui.label("Status: Running", ui.dark_grey),
      ui.label("●", ui.green),
    ]),

    ui.label("I am a simplified second row", ui.dark_grey),
  ])
}

pub fn main() -> Nil {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}
