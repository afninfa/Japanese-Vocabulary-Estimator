pub type Model {
  Model(counter: Int, theme: Theme)
}

pub type Msg {
  UserClickedIncrement
  UserClickedDecrement
  UserClickedThemeToggle
}

pub type Theme {
  Light
  Dark
}
