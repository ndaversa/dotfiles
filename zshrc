# Path to your Oh My Zsh installation.


export PATH="$HOME/.local/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
if [ "$(uname)" = "Darwin" ]; then
  export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
fi

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
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
eval "$(rbenv init -)"

# Only initialize aactivator if it's installed
if command -v aactivator >/dev/null 2>&1; then
  eval "$(aactivator init)"
fi

# usage:
# cat file | pbcopy
# or: some_command | pbcopy
pbcopy() {
  base64 | tr -d '\n' | awk '{printf "\033]52;c;%s\007", $0}'
}

slack_topic_sync_with_onpoint_schedule() {
  paasta local-run \
    -s reminder \
    -c norcal-devc \
    -i biz-multiloc-attribution-slack-topic.set-channel-topic \
    --pull \
    --volume /nail/home/ndaversa/reminder/code/biz_multiloc_attribution/weekly_channel_topic.py:/code/biz_multiloc_attribution/weekly_channel_topic.py \
    "$@"
}

pxp_sync_onpoint() {
  # Directory you must run from
  local workdir="/nail/home/ndaversa/airtable_integration"
  local venv_bin="$workdir/virtualenv_run/bin"

  if [[ ! -d "$workdir" ]]; then
    echo "Error: required directory does not exist: $workdir"
    return 1
  fi

  pushd "$workdir" >/dev/null || {
    echo "Error: could not cd into $workdir"
    return 1
  }

  # Ensure venv bin exists and prepend it to PATH
  if [[ ! -d "$venv_bin" ]]; then
    echo "Error: virtualenv bin directory not found: $venv_bin"
    popd >/dev/null
    return 1
  fi

  export PATH="$venv_bin:$PATH"

  if ! command -v dotenv >/dev/null 2>&1; then
    echo "Error: 'dotenv' not found even after prepending $venv_bin to PATH."
    popd >/dev/null
    return 1
  fi

  # ---------------- Team selection menu ----------------
  local -a teams=(
    "Biz MultiLoc - Attribution"
    "Biz MultiLoc - Value"
  )

  echo "Select team:"
  local i
  for i in {1..${#teams[@]}}; do
    echo "  $i) ${teams[$i]}"
  done
  echo "Press Enter for default [1]:"

  local team_choice
  read -r "team_choice?Team number: "

  if [[ -z "$team_choice" ]]; then
    team_choice=1
  fi

  # Must be an integer between 1 and ${#teams[@]}
  if [[ "$team_choice" != <-> ]] || (( team_choice < 1 || team_choice > ${#teams[@]} )); then
    echo "Error: invalid team selection."
    popd >/dev/null
    return 1
  fi

  local team="${teams[$team_choice]}"
  echo "TEAM: $team"
  echo
  # -----------------------------------------------------

  local default_future_days=60
  local future_days

  # Optional positional arg overrides the prompt
  if [[ -n "$1" ]]; then
    future_days="$1"
  else
    read -r "future_days?How many days into the future for END_DATE? (default ${default_future_days}): "
    if [[ -z "$future_days" ]]; then
      future_days=$default_future_days
    fi
  fi

  # Strict non-negative integer check (zsh)
  if [[ "$future_days" != <-> ]]; then
    echo "Error: please enter a non-negative integer for days."
    popd >/dev/null
    return 1
  fi

  local start_date end_date

  # macOS (BSD) date vs GNU date
  if date -v-14d +%Y-%m-%d >/dev/null 2>&1; then
    start_date=$(date -v-14d +%Y-%m-%d)
    end_date=$(date -v+${future_days}d +%Y-%m-%d)
  else
    start_date=$(date -d "14 days ago" +%Y-%m-%d)
    end_date=$(date -d "+${future_days} days" +%Y-%m-%d)
  fi

  echo "Using start date: $start_date   (today - 14 days)"
  echo "Using end date:   $end_date     (today + ${future_days} days)"
  echo

  # Base command (without --dry-run)
  local base_cmd=(
    dotenv run -- python -m airtable_integration.pxp_sync
    --team "$team"
    --onpoint
    --start-date "$start_date"
    --end-date "$end_date"
  )

  echo "Running dry-run:"
  printf '  %q ' "${base_cmd[@]}" --dry-run
  echo
  echo "------------------------------------------------------------"
  "${base_cmd[@]}" --dry-run
  local cmd_status=$?
  echo "------------------------------------------------------------"

  if (( cmd_status != 0 )); then
    echo "Dry-run failed with exit code ${cmd_status}. Not continuing."
    popd >/dev/null
    return $cmd_status
  fi

  echo
  local answer
  read -r "answer?Run for real (without --dry-run)? [y/N]: "
  if [[ "$answer" == [yY] || "$answer" == [yY][eE][sS] ]]; then
    echo "Running for real:"
    printf '  %q ' "${base_cmd[@]}"
    echo
    echo "------------------------------------------------------------"
    "${base_cmd[@]}"
    echo "------------------------------------------------------------"
  else
    echo "Aborted; only dry-run was executed."
  fi

  popd >/dev/null
}
