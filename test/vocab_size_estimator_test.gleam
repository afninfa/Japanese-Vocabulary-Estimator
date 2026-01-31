import gleam/list
import gleam/set
import gleeunit
import neyman_algorithm.{new_bucket, neyman_allocation}

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  let name = "Joe"
  let greeting = "Hello, " <> name <> "!"

  assert greeting == "Hello, Joe!"
}

pub fn neyman_initialisation_test() {
  let raw_buckets = [
    new_bucket(set.from_list(["eat", "see", "go"]), 0),
    new_bucket(set.from_list(["brother", "friend", "book"]), 1),
    new_bucket(set.from_list(["school", "movie", "doctor"]), 2),
    new_bucket(set.from_list(["education", "phobia", "issue"]), 3),
    new_bucket(set.from_list(["arachnid", "vascular", "economics"]), 4),
  ]
  let initialised_buckets = neyman_allocation(raw_buckets, 10)
  initialised_buckets
  |> list.each(fn(bucket) {
    assert bucket.samples_todo == 3
    // 2 from the budget of 10 plus 1
  })
  let initialised_buckets = neyman_allocation(raw_buckets, 15)
  initialised_buckets
  |> list.each(fn(bucket) {
    assert bucket.samples_todo == 4
    // 3 from the budget of 15 plus 1
  })
  let initialised_buckets = neyman_allocation(raw_buckets, 20)
  initialised_buckets
  |> list.each(fn(bucket) {
    assert bucket.samples_todo == 5
    // 4 from the budget of 20 plus 1
  })
}
