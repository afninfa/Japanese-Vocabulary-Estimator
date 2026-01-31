import components as ui
import gleam/int
import gleam/list
import gleam/set
import lustre
import neyman_algorithm.{new_bucket}
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
  Model(
    theme: t.Light,
    buckets: neyman_algorithm.neyman_allocation(
      [
        new_bucket(set.from_list(["eat", "see", "go"])),
        new_bucket(set.from_list(["brother", "friend", "book"])),
        new_bucket(set.from_list(["school", "movie", "doctor"])),
        new_bucket(set.from_list(["education", "phobia", "issue"])),
        new_bucket(set.from_list(["arachnid", "cardiovascular", "economics"])),
      ],
      16,
    ),
  )
}

// fn find_selected_bucket(model: Model) -> #(Model, Bucket) {
//   let selected_bucket =
//     model.buckets
//     |> list.find(fn(bucket) { bucket.samples_todo > 0 })
//   case selected_bucket {
//     Ok(bucket) -> #(model, bucket)
//     _ -> {
//       let new_buckets = neyman_algorithm.neyman_allocation(model.buckets, 16)
//       let new_model = Model(..model, buckets: new_buckets)
//       find_selected_bucket(new_model)
//     }
//   }
// }

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
  ])
}

pub fn main() -> Nil {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}
