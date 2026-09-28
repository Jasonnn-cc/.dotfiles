use std/config env-conversions

# |=< CONFIGURATION >=================|

$env.config.show_banner = false
$env.config.use_kitty_protocol = true
$env.config.rm.always_trash = true

# |=< NUSHELL COMPLETION >============|

$env.config.completions.external.completer = {|place|
    carapace ($place.command | first) nushell ...$place.command | from json
}

# |=< DIRENV >========================|

# Initialize the PWD hook as an empty list if it doesn't exist
$env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

$env.config.hooks.env_change.PWD ++= [{||
  if (which direnv | is-empty) {
    # If direnv isn't installed, do nothing
    return
  }

  direnv export json | from json | default {} | load-env
  # If direnv changes the PATH, it will become a string and we need to re-convert it to a list
  $env.PATH = do (env-conversions).path.from_string $env.PATH
}]

# |=< ALIASES >=======================|

alias sudo = sudo-rs
alias l = ls
alias cl = clear
alias gg = ginkgo

# |=< CONSTANTS >=====================|

const TMP_DIR = $nu.temp-dir | path join "nu/"

# |=< CUSTOM COMMANDS >===============|

# Stops the graphical session and powers the system off
@example "Shutdown the system... sometimes" {if (random bool --bias (1 / 6)) {shutdown}}
def shutdown []: nothing -> nothing {
  systemctl poweroff
}

# Move a file or directory to a destination leaving behind a symlink
@example "Move and link the nushell config folder to a dotfiles repo" {mvln ~/.config/nushell/ ~/.dotfiles}
@example "Give the moved file a name" {mvln ~/.zshrc ~/.dotfiles/zshrc}
def mvln [src: path, dest: path]: nothing -> nothing {
  if not ($src | path exists) {
    let span = (metadata $src).span
    error make {msg: $"Source does not exist: ($src)", label: {text: "path here", span: $span}}
  }

  mut target_dest = ($dest | path expand)
  if ($dest | path type) == "dir" {
    $target_dest = $target_dest | path join ($src | path basename)
  }

  mv $src $target_dest
  ln -s $target_dest ( $src | str trim -c '/' )
}

# Move a symlink's target to the symlink's path and remove the symlink
@example "Undo a symlink created by mvln" {unln ~/.zshrc}
def unln [link: path]: nothing -> nothing {
  let link_path = ($link | path expand --no-symlink)
  if ($link_path | path type) != "symlink" {
    let span = (metadata $link).span
    error make {msg: $"Not a symlink: ($link)", label: {text: "expected a symbolic link", span: $span}}
  }

  let target = (^readlink -- $link_path)
  let target_path = if ($target starts-with "/") {
    $target
  } else {
    $link_path | path dirname | path join $target
  }
  let source_path = ($target_path | path expand)
  if not ($source_path | path exists) {
    let span = (metadata $link).span
    error make {msg: $"Symlink target does not exist: ($target_path)", label: {text: "symlink path here", span: $span}}
  }

  rm --permanent $link_path
  mv $source_path $link_path
}

# Makes a temporary file in /tmp/nu/ and returns it's path, pipe input to fill it's contents.
@example "Diff the output of two commands" {diff (ls | to text | as-tmp) (ls .. | to text | as-tmp)}
@example "Edit all files that contain 'fox' as a quickfix" {rg fox --vimgrep | as-tmp | nvim -q $in}
def as-tmp [--directory (-d)]: any -> path {
  let content = $in
  mkdir $TMP_DIR

  if ($directory) {
    let tmp = mktemp --tmpdir-path $TMP_DIR XXXXXXXX --directory
    return $tmp
  }

  let tmp = mktemp --tmpdir-path $TMP_DIR XXXXXXXX
  if ($content != null) {
    $content | save -f $tmp
  }
  $tmp
}

# Starts a new nu session in a temporary folder, returns the folder's path
@example "Open the scratchpad dir" {scratchpad}
def scratchpad [--no-history]: nothing -> path {
  let tmp_dir = as-tmp -d
  mut flags = []

  if $no_history {
    $flags ++= [--no-history]
  }

  nu ...$flags --execute $"cd ($tmp_dir)"
  $tmp_dir
}
