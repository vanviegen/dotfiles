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

bindkey '^R' history-incremental-search-backward
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word


# To fix special keys, the $terminfo solution is used from: http://zshwiki.org/home/zle/bindkeys

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}


# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
function zle-line-init () {
    echoti smkx
}
function zle-line-finish () {
    echoti rmkx
}
zle -N zle-line-init
zle -N zle-line-finish 
