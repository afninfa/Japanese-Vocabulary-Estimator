import components as ui
import gleam/int
import gleam/list
import gleam/set
import lustre
import neyman_algorithm.{type Bucket, type BucketId, new_bucket}
import types.{type Model, type Msg, Model} as t

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    t.UserClickedThemeToggle ->
      case model.theme {
        t.Light -> Model(..model, theme: t.Dark)
        t.Dark -> Model(..model, theme: t.Light)
      }
    t.UserClickedDontKnow -> model
    t.UserClickedKnow -> model
  }
}

fn init(_args) -> Model {
  Model(
    theme: t.Light,
    buckets: neyman_algorithm.neyman_allocation(
      [
        new_bucket(set.from_list(["eat", "see", "go"]), 0),
        new_bucket(set.from_list(["brother", "friend", "book"]), 1),
        new_bucket(set.from_list(["school", "movie", "doctor"]), 2),
        new_bucket(set.from_list(["education", "phobia", "issue"]), 3),
        new_bucket(set.from_list(["arachnid", "vascular", "economics"]), 4),
      ],
      16,
    ),
  )
}

fn find_selected_bucket(buckets: List(Bucket)) -> BucketId {
  let assert Ok(selected_bucket) =
    buckets
    |> list.find(fn(bucket) { bucket.samples_todo > 0 })
  selected_bucket.bucket_id
}

fn view(model: Model) {
  let selected_bucket_id = find_selected_bucket(model.buckets)
  ui.stack(model.theme, [
    ui.options_bar([
      ui.button(
        model.theme,
        "Colour Theme",
        ui.background_colour(model.theme),
        t.UserClickedThemeToggle,
      ),
      ui.label("Source code available at aaaaa", ui.text_colour(model.theme)),
    ]),

    ui.row(
      model.buckets
      |> list.map(fn(bucket) {
        ui.fraction_box(
          model.theme,
          bucket.successful_samples,
          bucket.samples_so_far,
          "Questions: " <> int.to_string(bucket.samples_todo),
          bucket.bucket_id == selected_bucket_id,
        )
      }),
    ),

    ui.row([ui.text(model.theme, "The word...")]),

    ui.row([
      ui.button(model.theme, "Don't know", ui.red, t.UserClickedDontKnow),
      ui.button(
        model.theme,
        "Know",
        ui.adaptive_green(model.theme),
        t.UserClickedKnow,
      ),
    ]),
  ])
}

pub fn main() -> Nil {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}
