/// A menu tree.
///
/// 
/// A `Choice` is an option the user can select that will return the associated `value`.
/// 
/// A `Submenu` will open display another list of choices when selected.
/// 
/// `label` is the text that will be displayed to represent a `Choice` or `Submenu` in the menu tree.
///
/// ## Examples:
/// ```
/// menu.new([
///   menu.Choice("choice 1", 1),
///   menu.Choice("choice 2", 2),
///   menu.Choice("choice 3", 3),
/// ])
/// ```
/// ```
/// menu.new([menu.Choice("yes", True), menu.Choice("no", False)])
/// ```
/// ```
/// menu.new([
///   menu.Submenu("submenu", [
///     menu.Submenu("another submenu", [
///       menu.Choice("i want an apple", Apple),
///       menu.Choice("i want a banana", Banana),
///       menu.Choice("i want an orange", Orange),
///     ]),
///   ]),
/// ])
/// ```
pub type Tree(t) {
  Choice(label: String, value: t)
  Submenu(label: String, choices: List(Tree(t)))
}

/// A `dmenu` command.
///
/// What you set this to will depend on what your preferred `dmenu` clone is!
///
/// ## Examples:
/// ```
/// menu.Command(run: "dmenu", with: [])
/// ```
/// ```
/// menu.Command(run: "rofi", with: ["-dmenu"])
/// ```
/// ```
/// // hack: setting `--cache-file=/dev/null` will prevent `wofi` from
/// // reordering the menu items based on which was most recently chosen
/// menu.Command(run: "wofi", with: ["--dmenu", "--prompt=gleemenu", "--cache-file=/dev/null"])
/// ```
pub type Command {
  Command(run: String, with: List(String))
}

/// A nice-looking way to create a menu tree.
///
/// ```
/// menu.new([Choice("yes", True), Choice("no", False)])
/// 
/// // is equivalent to
/// 
/// menu.Submenu("<root>", [Choice("yes", True), Choice("no", False)])
/// ```
pub fn new(choices choices: List(Tree(t))) -> Tree(t) {
  Submenu("<root>", choices)
}
