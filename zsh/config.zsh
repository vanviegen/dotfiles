export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true
#export TERM=xterm-256color 
export EDITOR='vim'

export PATH="$ZSH/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

if [ "$zshNoDirChange" = "" ] ; then
	cd $HOME
fi

if [ "$TERM" != "dumb" ]; then
	alias ls="ls -F --color=auto"
	alias l="ls -lAh --color=auto"
	alias ll="ls -l --color=auto"
	alias la="ls -A --color=auto"
fi

setopt AUTO_CD # why would you type 'cd dir' if you could just type 'dir'?
setopt AUTO_PUSHD # This makes cd=pushd
setopt PUSHD_IGNORE_DUPS

setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt PROMPT_SUBST # parameter expansion for prompt

setopt COMPLETE_IN_WORD
unsetopt AUTO_MENU # do not choose first option after 2x tab
setopt AUTO_PARAM_SLASH # complete directories with a trailing /
setopt COMPLETE_ALIASES # don't expand aliases _before_ completion has finished

if [ "$HISTFILE" = "" ] ; then
	HISTFILE=~/.zsh_history
fi
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY # add timestamps to history
setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY # adds history incrementally
setopt HIST_IGNORE_SPACE # don't add cmds starting with a whitespace to hist
setopt HIST_IGNORE_ALL_DUPS # don't record dupes in history

#zle -N newtab # Hmmm, this thing is thoroughly undocumented. Let's see what happens without it.

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

