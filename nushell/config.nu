# |=< ENVIRONMENT VARIABLES >=========|

$env.config.show_banner = false

$env.VISUAL = "nvim"
$env.EDITOR = "nvim"

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

# |=< ALIASES >=======================|

alias shutdown = systemctl poweroff
alias sudo = sudo-rs
alias l = ls
alias cl = clear

# |=< KEYBINDS >======================|

# |=< CUSTOM COMMANDS >===============|

# Move a file or directory to a destination leaving behind a symlink
def mvln [src: path, dest: path, ...rest] {
	mut target_dest = $dest | path expand
  if ($dest | path type) == "dir" {
    $target_dest = $target_dest | path join ($src | path basename)
  }
  
	mv $src $dest
	ln -s $target_dest $src ...$rest
}

# Makes a temporary file and returns it's path, pipe input to fill it's contents
def as-tmp [] {
  const tmp_path = ($nu.temp-dir | path join nu/)
  mkdir tmp_path
  let tmp = mktemp --tmpdir-path tmp_path XXXXXXXX
  $in | save -f $tmp
  $tmp
}
