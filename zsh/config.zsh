export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true
#export TERM=xterm-256color 
export EDITOR='vim'

export PATH="$ZSH/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

cd $HOME

if [ "$TERM" != "dumb" ]; then
	alias ls="ls -F --color=auto"
	alias l="ls -lAh --color=auto"
	alias ll="ls -l --color=auto"
	alias la="ls -A --color=auto"
fi

fpath=($ZSH/zsh/functions $fpath)

autoload -U $ZSH/zsh/functions/*(:t)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD

setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

zle -N newtab

bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

bindkey '^[[3~' delete-char
bindkey '^[^N' newtab
bindkey '^?' backward-delete-char

bindkey '^R' history-incremental-search-backward

