import neyman_algorithm.{type Bucket}

pub type Model {
  Model(theme: Theme, buckets: List(Bucket))
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
