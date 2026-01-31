import gleam/float
import gleam/int
import gleam/list
import gleam/set

pub type Bucket {
  Bucket(
    words: set.Set(String),
    successful_samples: Int,
    samples_so_far: Int,
    samples_todo: Int,
  )
}

fn float_corpus_size(buckets: List(Bucket)) {
  buckets
  |> list.map(fn(bucket) { set.size(bucket.words) })
  |> int.sum
  |> int.to_float
}

pub fn new_bucket(words) {
  assert set.size(words) == 3
  // All strata have the same size
  Bucket(words, 0, 0, 0)
}

fn proportion(bucket: Bucket) {
  case bucket.samples_so_far {
    0 -> panic as "Cannot calculate proportion with zero samples"
    _ -> Nil
  }
  int.to_float(bucket.successful_samples) /. int.to_float(bucket.samples_so_far)
}

pub fn sample_word(bucket: Bucket, sample_successful: Bool) {
  case bucket.samples_todo {
    0 -> panic as "Tried to sample on a bucket with zero samples todo"
    _ -> Nil
  }
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

fn variance(bucket: Bucket) -> Float {
  case bucket.samples_so_far {
    0 -> 0.25
    _ -> proportion(bucket) *. { 1.0 -. proportion(bucket) }
  }
}

fn standard_deviation(bucket: Bucket) -> Float {
  let assert Ok(result) = bucket |> variance |> float.square_root
  result
}

fn mean(nums: List(Float)) -> Float {
  { nums |> float.sum } /. { nums |> list.length |> int.to_float }
}

pub fn neyman_allocation(buckets: List(Bucket), budget: Int) -> List(Bucket) {
  // Make sure we have enough sample budget
  case budget < 2 * list.length(buckets) {
    True -> panic as "Need to do at least twice as many samples as buckets"
    False -> Nil
  }
  let assert Ok(first_bucket) = list.first(buckets)
  // Should not have any still unfinished. Buckets should all be the same size.
  buckets
  |> list.each(fn(this_bucket) {
    assert this_bucket.samples_todo == 0
    assert set.size(first_bucket.words) == set.size(this_bucket.words)
  })
  // Sum standard deviations of all buckets
  let sum_std_dev =
    buckets
    |> list.map(standard_deviation)
    |> float.sum
  // Fill with samples todo
  buckets
  |> list.map(fn(bucket) {
    let samples_todo =
      { standard_deviation(bucket) /. sum_std_dev } *. int.to_float(budget)
    Bucket(..bucket, samples_todo: float.round(samples_todo) + 1)
  })
}

pub fn margin_of_error(buckets: List(Bucket)) -> Int {
  // Buckets should all be the same size.
  let assert Ok(first_bucket) = list.first(buckets)
  buckets
  |> list.each(fn(this_bucket) {
    assert set.size(first_bucket.words) == set.size(this_bucket.words)
  })
  let sum_term =
    buckets
    |> list.map(fn(bucket) {
      variance(bucket) /. int.to_float(bucket.samples_so_far)
    })
    |> float.sum

  let k = int.to_float(list.length(buckets))
  let strata_term = 1.0 /. { k *. k }
  let assert Ok(root_term) = float.square_root(sum_term *. strata_term)
  let result = 1.96 *. root_term *. float_corpus_size(buckets)
  float.round(result)
}

pub fn estimation(buckets: List(Bucket)) -> Int {
  let average_proportion =
    buckets
    |> list.map(proportion)
    |> mean
  let estimate = float_corpus_size(buckets) *. average_proportion
  float.round(estimate)
}
