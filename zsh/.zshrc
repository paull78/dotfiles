

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# Disable Oh My Zsh theming (using Starship instead)
ZSH_THEME=""

# Starship prompt
eval "$(starship init zsh)"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting you-should-use zsh-bat)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


export LC_ALL=en_US.UTF-8
export NVM_DIR="$(brew --prefix nvm)"
[ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Configure fzf to use bat for preview
export FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

. "$HOME/.local/bin/env"
. "$HOME/.deno/env"


# eza aliases to replace ls
alias ls='eza --color=always --group-directories-first'
alias ll='eza -la --color=always --group-directories-first'
alias la='eza -a --color=always --group-directories-first'
alias lt='eza --tree --color=always --group-directories-first'
alias l='eza -F --color=always --group-directories-first'
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
# End of LM Studio CLI section


alias cd='z'

alias claude-mem='bun "$HOME/.claude/plugins/cache/thedotmack/claude-mem/10.6.2/scripts/worker-service.cjs"'

# Zellij layouts
alias zjbais='zellij --layout bais'
alias zjb4='zellij --layout b4'

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"; fi

# Added by ~/code/local-dev-stack/bin/init.sh — process-compose alias
alias pc='process-compose -f $HOME/code/local-dev-stack/process-compose.yml'

# pclog — follow a process-compose log in less, backed by a real file
# so `v` opens it in $EDITOR (nvim) for grep/yank/etc.
#
#   pclog bas              # follow inside less, tee to /tmp/pc-bas.log
#
# Inside less:
#   Ctrl-C   → pause follow, enter nav mode (j/k/g/G, /pattern, n/N)
#   Shift-F  → resume follow
#   v        → open the file in $EDITOR
#   q        → quit (producer is killed)
#
# Tail from another shell with: tail -f /tmp/pc-<name>.log
pclog() {
    if [[ -z "$1" ]]; then
        echo "usage: pclog <process-name>" >&2
        return 2
    fi
    local out="/tmp/pc-$1.log"
    echo "→ writing to $out" >&2
    : > "$out"
    # Producer runs in the background so Ctrl-C in less doesn't reach it;
    # less +F follows the file like tail -f. On quit, kill the producer.
    ( trap '' INT; process-compose process logs "$1" -f >> "$out" ) &
    local pid=$!
    less -R +F "$out"
    kill "$pid" 2>/dev/null
}

# Machine-local secrets and overrides, not tracked in dotfiles
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

eval "$(zoxide init zsh)"
