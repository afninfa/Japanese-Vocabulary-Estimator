import gleam/list
import neyman_algorithm.{type Bucket, type BucketId}

pub type Model {
  Model(
    theme: Theme,
    buckets: List(Bucket),
    current_word: String,
    active_bucket_id: BucketId,
  )
}

pub type Msg {
  UserClickedThemeToggle
  UserClickedDontKnow
  UserClickedKnow
}

pub type Theme {
  Light
  Dark
}

pub fn reduce_samples_todo_on_active_bucket_after_sample(model: Model) -> Model {
  let updated_buckets =
    model.buckets
    |> list.map(fn(bucket) {
      case bucket.bucket_id == model.active_bucket_id {
        True ->
          neyman_algorithm.Bucket(
            ..bucket,
            samples_todo: bucket.samples_todo - 1,
          )
        False -> bucket
      }
    })
  Model(..model, buckets: updated_buckets)
}

pub fn update_active_bucket_id_after_sample(model: Model) -> Model {
  let active_bucket = get_active_bucket(model)
  let max_bucket_id = { model.buckets |> list.length } - 1
  let next_active_bucket_id = case active_bucket.samples_todo {
    0 -> active_bucket.bucket_id + 1
    _ -> active_bucket.bucket_id
  }
  case next_active_bucket_id > max_bucket_id {
    True -> {
      Model(
        ..model,
        active_bucket_id: 0,
        buckets: neyman_algorithm.neyman_allocation(model.buckets, 16),
      )
    }
    False -> Model(..model, active_bucket_id: next_active_bucket_id)
  }
}

pub fn update_active_bucket_data_after_sample(
  model: Model,
  sample_successful: Bool,
) -> Model {
  let updated_buckets =
    model.buckets
    |> list.map(fn(bucket) {
      case bucket.bucket_id == model.active_bucket_id {
        True ->
          neyman_algorithm.process_sample_result(bucket, sample_successful)
        False -> bucket
      }
    })
  Model(..model, buckets: updated_buckets)
}

pub fn get_active_bucket(model: Model) -> Bucket {
  let only_active_bucket_remains =
    model.buckets
    |> list.filter(fn(bucket) { bucket.bucket_id == model.active_bucket_id })
  assert list.length(only_active_bucket_remains) == 1
  let assert Ok(active_bucket) = only_active_bucket_remains |> list.first
  active_bucket
}
