HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt autocd extendedglob nomatch
bindkey -e

alias sudo=sudo-rs
alias shutdown="systemctl poweroff"

# The following lines were added by compinstall
zstyle :compinstall filename '/home/citrus/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
