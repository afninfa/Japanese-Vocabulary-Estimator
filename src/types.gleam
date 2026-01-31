import neyman_algorithm.{type Bucket}

pub type Model {
  Model(theme: Theme, buckets: List(Bucket))
}

pub type Msg {
  UserClickedThemeToggle
}

pub type Theme {
  Light
  Dark
}
