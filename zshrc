# Shell Configuration
export EDITOR=vim
export POWERLINE_BASH_CONTINUATION=1
export POWERLINE_BASH_SELECT=1

# Path Exports
export PYTHON3_HOME="/usr/local/lib/python3" # Create a symlink to the latest 3.x
export POWERLINE_ROOT="${PYTHON3_HOME}/site-packages"
export NODE_PATH="/usr/local/lib/node"
export GOPATH="${HOME}/Code/go"
export GOBIN="${GOPATH}/bin"
export LOCAL_GOBIN="/usr/local/go/bin"
export VSCODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export NPM_BIN="/usr/local/share/npm/bin"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"

export PATH="/usr/local/bin:${PATH}"
export PATH="${PATH}:${HOME}/bin"
export PATH="${PATH}:${NPM_BIN}"
export PATH="${PATH}:${GOPATH}"
export PATH="${PATH}:${GOBIN}"
export PATH="${PATH}:${HOME}/.local/bin"
export PATH="${PATH}:${VSCODE_BIN}"
export PATH="${PATH}:${LOCAL_GOBIN}"
export PATH="${PATH}:${HOME}/.krew/bin"
export PATH="/usr/local/opt/openjdk/bin:${PATH}"

# Aliases
alias now="date '+%Y-%m-%d-%H.%M.%S'"
alias ls="ls -G"
alias ll="ls -l"
alias la="ll -a"
alias grep="grep --color=auto"
alias glhf="git log --follow -p --"
alias gitwhere="git branch --contains"
alias jsonfmt='python3 -mjson.tool'
alias pip='pip3'
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '\n'"
alias uuidc="uuid | pbcopy"

# ZSH Bindkeys
bindkey -e
bindkey '\e\e[C' forward-word
bindkey '\e\e[D' backward-word

# ZSH Options
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# rbenv
eval "$(rbenv init -)"

# Sources
# test -f "${HOME}/.config/exercism/exercism_completion.bash" && . $_

# Powerline
if [ -f `which powerline-daemon` ]; then
   powerline-daemon -q
   POWERLINE_BASH_CONTINUATION=1
   POWERLINE_BASH_SELECT=1
   . "${POWERLINE_ROOT}/powerline/bindings/zsh/powerline.zsh"
fi

# ZSH
fpath=(~/.zsh $fpath)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then . '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then . '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'; fi
