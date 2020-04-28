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

DISABLE_AUTO_TITLE=false

#terminal_title=`print -Pn "\e]2;lala\a"`
terminal_title=$(print -Pn "dir:\\%~x \ek%~\e\\")
export PROMPT=$'%0{\033k%~\033\\%}%K{$green}%F{$black} %n %K{$grey}%F{$green} %m %F{$yellow}%~$(git_dirty) %K{$black}%F{$grey}%F{$white} '

function precmd() {
	#print -Pn "@1\e]2;%55<...<%~\a" # plain xterm title ($3 for pwd)
#	print -Pn "lll\ek${pwd}\e\\"
}

# preexec is called just before any command line is executed
function preexec() {
	if [ -f ~/.display -a "$SSH_CONNECTION" != "" -a "$TMUX" != "" ]; then
		export DISPLAY=`cat ~/.display`
	fi

	print -Pn "\ek$1\e\\"
}

