import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import lists
import lustre
import model.{type Model, type Msg, Model} as t
import neyman_algorithm.{new_bucket}
import ui_utils as ui

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    t.UserClickedThemeToggle ->
      case model.theme {
        t.Light -> Model(..model, theme: t.Dark)
        t.Dark -> Model(..model, theme: t.Light)
      }
    t.UserClickedDontKnow ->
      model
      |> t.update_active_bucket_data_after_sample(False)
      |> t.update_active_bucket_id_after_sample
      |> t.update_currently_showing_word_after_sample
    t.UserClickedKnow ->
      model
      |> t.update_active_bucket_data_after_sample(True)
      |> t.update_active_bucket_id_after_sample
      |> t.update_currently_showing_word_after_sample
  }
}

fn init(_args) -> Model {
  let buckets = [
    lists.first_1000 |> string.split("\n") |> new_bucket(0),
    lists.second_1000 |> string.split("\n") |> new_bucket(1),
    lists.third_1000 |> string.split("\n") |> new_bucket(2),
    lists.fourth_1000 |> string.split("\n") |> new_bucket(3),
    lists.fifth_1000 |> string.split("\n") |> new_bucket(4),
    lists.sixth_1000 |> string.split("\n") |> new_bucket(5),
    lists.seventh_1000 |> string.split("\n") |> new_bucket(6),
    lists.eighth_1000 |> string.split("\n") |> new_bucket(7),
  ]
  let assert Ok(first_bucket) = list.first(buckets)
  Model(
    theme: t.Light,
    buckets: buckets,
    current_word: t.sample_from_bucket(first_bucket),
    active_bucket_id: 0,
  )
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
      ui.text_with_link(
        [
          #("Source code on ", None),
          #(
            "GitHub",
            Some(#(
              "https://github.com/afninfa/Japanese-Vocabulary-Estimator",
              ui.blue,
            )),
          ),
        ],
        ui.text_colour(model.theme),
      ),
    ]),

    ui.row([
      ui.label(
        "Estimate: "
          <> int.to_string(neyman_algorithm.estimation(model.buckets)),
        ui.text_colour(model.theme),
      ),
    ]),

    ui.row([
      ui.label(
        "Margin of error: "
          <> int.to_string(neyman_algorithm.margin_of_error(model.buckets)),
        ui.text_colour(model.theme),
      ),
    ]),

    ui.row(
      model.buckets
      |> list.map(fn(bucket) {
        ui.fraction_box(
          model.theme,
          bucket.successful_samples,
          bucket.samples_so_far,
          int.to_string(bucket.samples_todo),
          bucket.bucket_id == model.active_bucket_id,
        )
      }),
    ),

    ui.row([ui.text(model.theme, model.current_word)]),

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
