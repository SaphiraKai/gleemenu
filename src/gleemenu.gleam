import gleam/list
import gleam/result
import gleam/string

import shellout

import gleemenu/error.{type Error}
import gleemenu/menu.{Choice, Submenu}

/// Display a menu tree using the provided `dmenu` command.
///
/// You can create a menu tree using `menu.new`!
pub fn show_tree(
  tree tree: menu.Tree(t),
  with command: menu.Command,
) -> Result(t, Error) {
  case tree {
    Choice(value: value, ..) -> Ok(value)

    Submenu(choices: choices, ..) -> {
      let labels =
        choices
        |> list.map(fn(a) {
          case a {
            Choice(label: label, ..) -> label
            Submenu(label: label, ..) -> "󰉋  " <> label
          }
        })
      // TODO: figure out how to make this work lol
      // |> list.append(["󰌍  back"])

      use response <- result.try(show(menu: command, with: labels))

      let choice =
        choices
        |> list.find(fn(a) {
          case response {
            "󰉋  " <> response | response -> response == a.label
          }
        })
        |> result.map_error(fn(_) {
          let labels = labels |> list.map(fn(a) { "'" <> a <> "'" })

          error.InvalidResponse(
            expected: "one of: " <> string.join(labels, ", "),
            found: response,
          )
        })

      case choice {
        Ok(choice) -> show_tree(tree: choice, with: command)
        Error(error.InvalidResponse(..)) -> show_tree(tree:, with: command)
        Error(error) -> Error(error)
      }
    }
  }
}

/// Display a list of choices using the provided `dmenu` command.
pub fn show(
  menu command: menu.Command,
  with choices: List(String),
) -> Result(String, Error) {
  let menu.Command(run, with) = command

  let commandline =
    "printf '"
    <> string.join(choices, "\n")
    <> "' | "
    <> string.join([run, ..with], " ")
    // TODO: remove this if shellout allows filtering out stderr from output
    <> " 2>/dev/null"

  use response <- result.map(
    shellout.command("sh", ["-euc", commandline], in: ".", opt: [])
    |> result.map_error(error.command_failed),
  )

  string.trim(response)
}
