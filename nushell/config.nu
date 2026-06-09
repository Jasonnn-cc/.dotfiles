# |=< ENVIRONMENT VARIABLES >=========|

$env.config.show_banner = false

$env.VISUAL = "nvim"
$env.EDITOR = "nvim"

# |=< NUSHELL COMPLETION >============|

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
mkdir $"($nu.cache-dir)"
carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"

source $"($nu.cache-dir)/carapace.nu"

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
