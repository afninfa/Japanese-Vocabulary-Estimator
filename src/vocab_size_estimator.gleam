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
        model.theme,
        "Colour Theme",
        ui.background_colour(model.theme),
        t.UserClickedThemeToggle,
      ),
    ]),

    ui.row([ui.text(model.theme, "Coming soon")]),

    ui.row([
      ui.fraction_box(model.theme, 0, 0, "Hello, world!", False),
      ui.fraction_box(model.theme, 1, 3, "Hello, world!", False),
      ui.fraction_box(model.theme, 1, 4, "Hello, world!", False),
      ui.fraction_box(model.theme, 4, 5, "Hello, world!", True),
      ui.fraction_box(model.theme, 5, 6, "Hello, world!", False),
      ui.fraction_box(model.theme, 2, 7, "Hello, world!", False),
      ui.fraction_box(model.theme, 3, 8, "Hello, world!", False),
      ui.fraction_box(model.theme, 4, 9, "Hello, world!", False),
    ]),

    ui.label("I am a simplified second row", ui.text_colour(model.theme)),
  ])
}

pub fn main() -> Nil {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}
