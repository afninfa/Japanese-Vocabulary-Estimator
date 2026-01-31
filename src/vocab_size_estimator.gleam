import components as ui
import gleam/int
import gleam/list
import gleam/set
import gleam/string
import lustre
import neyman_algorithm.{type Bucket, new_bucket}
import types.{type Model, type Msg, Model} as t

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    t.UserClickedThemeToggle ->
      case model.theme {
        t.Light -> Model(..model, theme: t.Dark)
        t.Dark -> Model(..model, theme: t.Light)
      }
  }
}

fn init(_args) -> Model {
  Model(theme: t.Light, buckets: [
    new_bucket(set.from_list(["eat", "see", "go"])),
    new_bucket(set.from_list(["school", "movie", "doctor"])),
    new_bucket(set.from_list(["education", "phobia", "issue"])),
    new_bucket(set.from_list(["arachnid", "cardiovascular", "economics"])),
  ])
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

    ui.row(
      model.buckets
      |> list.map(fn(bucket) {
        ui.fraction_box(
          model.theme,
          bucket.successful_samples,
          bucket.samples_so_far,
          "Samples to take: " <> int.to_string(bucket.samples_todo),
          False,
        )
      }),
    ),

    ui.label("I am a simplified second row", ui.text_colour(model.theme)),
  ])
}

pub fn main() -> Nil {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}
