# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"
DEFAULT_USER="ndaversa"
zstyle ':omz:update' mode auto      # update automatically without asking

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
  1password
  git
  github
  brew
  vi-mode
  iterm2
  macos
  ssh
  zsh-autosuggestions
  zsh-completions 
  zsh-history-substring-search 
  zsh-syntax-highlighting
)
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/oh-my-zsh.sh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10' # default colour doesn't work well with solarized dark in iterm2
bindkey '^F' autosuggest-accept # fish shell style ctrl-f to accept suggestion

alias vi="vim"

export GPG_TTY=$(tty)
eval "$(rbenv init -)"
