# gleemenu

[![Package Version](https://img.shields.io/hexpm/v/gleemenu)](https://hex.pm/packages/gleemenu)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gleemenu/)

![gleemenu](https://github.com/user-attachments/assets/2458e7dd-6fe9-4e7f-82b1-8daa4c5bbfce)

```sh
gleam add gleemenu@1
```
```gleam
import gleemenu
import gleemenu/menu.{Choice, Submenu}

type Choice {
  Choice1
  Choice2
  Choice3
  Choice4
  Choice5
  Choice6
}

pub fn main() {
  let menu_tree =
    [
      Choice("choice 1", Choice1),
      Choice("choice 2", Choice2),
      Submenu("submenu 1", [
        Choice("choice 3", Choice3),
        Choice("choice 4", Choice4),
      ]),
      Submenu("submenu 2", [
        Choice("choice 5", Choice5),
        Choice("choice 6", Choice6),
      ]),
    ]
    |> menu.new

  let command = menu.Command(run: "dmenu", with: [])

  use response <- result.try(menu_tree |> gleemenu.show_tree(with: command))

  io.debug(response)

  Ok(Nil)
}
```

Further documentation can be found at <https://hexdocs.pm/gleemenu>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
