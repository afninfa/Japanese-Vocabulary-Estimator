import gleam/float
import gleam/int
import gleam/list

pub type Bucket {
  Bucket(
    words: List(String),
    successful_samples: Int,
    samples_so_far: Int,
    samples_todo: Int,
  )
}

pub fn new_bucket(words) {
  let assert 750 = list.length(words)
  Bucket(words, 0, 0, 0)
}

pub fn proportion(bucket: Bucket) {
  case bucket.samples_so_far {
    0 -> panic as "Cannot calculate proportion with zero samples"
    _ ->
      int.to_float(bucket.successful_samples)
      /. int.to_float(bucket.samples_so_far)
  }
}

pub fn sample_word(bucket: Bucket, sample_successful: Bool) {
  case bucket.samples_todo {
    0 -> panic as "Tried to sample on a bucket with zero samples todo"
    _ ->
      Bucket(
        ..bucket,
        samples_so_far: bucket.samples_so_far + 1,
        samples_todo: bucket.samples_todo - 1,
        successful_samples: bucket.successful_samples
          + case sample_successful {
            True -> 1
            False -> 0
          },
      )
  }
}

fn variance(bucket: Bucket) -> Float {
  proportion(bucket) *. { 1.0 -. proportion(bucket) }
}

fn standard_deviation(bucket: Bucket) -> Float {
  let assert Ok(result) = float.square_root(variance(bucket))
  result
}

fn neyman_allocation(buckets: List(Bucket), budget: Int) -> List(Bucket) {
  // Should not have any still unfinished
  buckets
  |> list.each(fn(bucket) {
    let assert 0 = bucket.samples_todo
  })
  // Sum standard deviations of all buckets
  let assert Ok(sum_std_dev) =
    buckets
    |> list.map(standard_deviation)
    |> list.reduce(fn(acc, x) { acc +. x })
  // Fill with samples todo
  buckets
  |> list.map(fn(bucket) {
    let samples_todo =
      { standard_deviation(bucket) /. sum_std_dev } *. int.to_float(budget)
    Bucket(..bucket, samples_todo: float.round(samples_todo))
  })
}
