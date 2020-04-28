green=154
white=white
yellow=222
grey=238
black=232
red=9

git_dirty() {
	st=$(/usr/bin/git status 2>/dev/null | tail -n 1)
	if [[ $st == "" ]]
	then
		echo ""
	else
		if [[ $st == "nothing to commit, working tree clean" ]]
		then
			echo " %F{$green}$(git_prompt_info)"
		else
			echo " %F{$red}$(git_prompt_info)"
		fi
	fi
}

git_prompt_info () {
	ref=$(/usr/bin/git symbolic-ref HEAD 2>/dev/null) || return
	echo "${ref#refs/heads/}"
}

export PROMPT=$'%K{$green}%F{$black} %n %K{$grey}%F{$green} %m %F{$yellow}%~$(git_dirty) %K{$black}%F{$grey}%F{$white} '

function precmd() {
	print -Pn "\e]2;%55<...<%~\a" # plain xterm title ($3 for pwd)
}

# preexec is called just before any command line is executed
function preexec() {
	if [ -f ~/.display -a "$SSH_CONNECTION" != "" -a "$TMUX" != "" ]; then
		export DISPLAY=`cat ~/.display`
	fi
	print -Pn "\e]2;$1\a" # plain xterm title ($3 for pwd)
}

