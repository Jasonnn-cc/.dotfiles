use std/config env-conversions 

# |=< CONFIGURATION >=================|

$env.config.show_banner = false

# |=< NUSHELL COMPLETION >============|

let fish_completer = {|spans|
  fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
  | from tsv --flexible --noheaders --no-infer
  | rename value description
  | update value {|row|
    let value = $row.value
    let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
    if ($need_quote and ($value | path exists)) {
      let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
      $'"($expanded_path | str replace --all "\"" "\\\"")"'
    } else {$value}
  }
}

$env.config = {
  completions: {
    external: {
      enable: true
      completer: $fish_completer
    }
  }
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

alias shutdown = systemctl poweroff
alias sudo = sudo-rs
alias l = ls
alias cl = clear

# |=< CONSTANTS >=====================|

const TMP_DIR = $nu.temp-dir | path join "nu/"

# |=< CUSTOM COMMANDS >===============|

# Move a file or directory to a destination leaving behind a symlink
def mvln [src: path, dest: path, ...rest] {
  if not ($src | path exists) {
    error make {msg: $"Source does not exist: ($src)"}
  }

  mut target_dest = ($dest | path expand)
  if ($dest | path type) == "dir" {
    $target_dest = $target_dest | path join ($src | path basename)
  }

  mv $src $target_dest
  ln -s ...$rest $target_dest ( $src | str trim -c '/' )
}

# Makes a temporary file in /tmp/nu/ and returns it's path, pipe input to fill it's contents
def as-tmp [] {
  let content = $in
  mkdir $TMP_DIR

  let tmp = mktemp --tmpdir-path $TMP_DIR XXXXXXXX
  if ($content != null) {
    $content | save -f $tmp
  }
  $tmp
}
