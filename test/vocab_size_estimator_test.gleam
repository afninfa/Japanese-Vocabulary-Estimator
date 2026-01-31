import gleam/list
import gleeunit
import neyman_algorithm.{new_bucket, neyman_allocation, verify_bucket_ids}

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn neyman_initialisation_test() {
  let raw_buckets = [
    new_bucket(["eat", "see", "go"], 0),
    new_bucket(["brother", "friend", "book"], 1),
    new_bucket(["school", "movie", "doctor"], 2),
    new_bucket(["education", "phobia", "issue"], 3),
    new_bucket(["arachnid", "vascular", "economics"], 4),
  ]
  let initialised_buckets = neyman_allocation(raw_buckets, 10)
  initialised_buckets
  |> list.each(fn(bucket) {
    assert bucket.samples_todo == 1
    // Neyman allocates none because variance is zero, plus 1 because I add one to all buckets
  })
  verify_bucket_ids(initialised_buckets)
  let initialised_buckets = neyman_allocation(raw_buckets, 15)
  initialised_buckets
  |> list.each(fn(bucket) {
    assert bucket.samples_todo == 1
  })
  verify_bucket_ids(initialised_buckets)
  let initialised_buckets = neyman_allocation(raw_buckets, 20)
  initialised_buckets
  |> list.each(fn(bucket) {
    assert bucket.samples_todo == 1
  })
  verify_bucket_ids(initialised_buckets)
}
