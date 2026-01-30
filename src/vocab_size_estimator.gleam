import components as ui
import lustre
import types.{type Model, type Msg, Model} as t

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    t.UserClickedThemeToggle ->
      case model.theme {
        t.Light -> Model(theme: t.Dark)
        t.Dark -> Model(theme: t.Light)
      }
  }
}

fn init(_args) -> Model {
  Model(theme: t.Light)
}

fn view(model: Model) {
  ui.stack(model.theme, [
    ui.options_bar([
      ui.button(
        "Change Theme",
        ui.background_colour(model.theme),
        t.UserClickedThemeToggle,
      ),
    ]),

    ui.row([ui.text(model.theme, "Coming soon")]),

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
