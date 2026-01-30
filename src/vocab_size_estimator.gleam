import components as ui
import gleam/int
import gleam/option.{Some}
import lustre
import types.{type Model, type Msg, Model} as t

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    t.UserClickedIncrement -> Model(..model, counter: model.counter + 1)
    t.UserClickedDecrement -> Model(..model, counter: model.counter - 1)
    t.UserClickedThemeToggle ->
      case model.theme {
        t.Light -> Model(..model, theme: t.Dark)
        t.Dark -> Model(..model, theme: t.Light)
      }
  }
}

fn init(_args) -> Model {
  Model(counter: 0, theme: t.Light)
}

fn view(model: Model) {
  let counter_repr = int.to_string(model.counter)

  ui.stack(model.theme, [
    ui.options_bar([
      ui.button("Change Theme", ui.light_grey, t.UserClickedThemeToggle),
    ]),

    ui.row([
      ui.button("+", ui.green, t.UserClickedIncrement),
      ui.text(model.theme, counter_repr),
      ui.button("-", ui.red, t.UserClickedDecrement),
    ]),

    ui.row([
      ui.label("Status: Running", ui.text_colour(model.theme)),
      ui.label("●", ui.green),
    ]),

    ui.label("I am a simplified second row", ui.text_colour(model.theme)),
  ])
}

pub fn main() -> Nil {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}
