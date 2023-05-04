if status is-interactive
    # Commands to run in interactive sessions can go here

    # Start tmux instead, if we're not already in tmux
    if test -z "$TMUX" -a "$TERM_PROGRAM" != "vscode"
        if command -v tmux > /dev/null
            exec tmux new-session -A -s $USER-main
        end
        echo Failed to start tmux
    end

    function preexec --on-event fish_preexec
        # Set DISPLAY to current value in case we may have reattached over ssh to tmux
        if test -n "$SSH_CONNECTION" -a -n "$TMUX"
            set -x DISPLAY (tmux show-env | sed -n 's/^DISPLAY=//p')
        end

        # Get the first argument that is not 'ssh' or an environment assignment
        set args (string split ' ' $argv[1])
        set index 1
        while test $index -le (count $args)
            set name $args[$index]
            if test "$name" = "ssh"
            or test -z "$name"
            or string match '*=*' "$name"
	            set index (expr $index + 1)
		    else
                break
            end
        end

        # Set the tmux tab name to the program name
        echo -en "\ek$name\e\\"
    end

    function postexec --on-event fish_postexec
        # Set the tmux tab name to the current directory
        set pwd (prompt_pwd)
        echo -en "\ek$pwd\e\\"
    end

    postexec
end

set -U fish_greeting
set -U fish_user_paths "$HOME/.dotfiles/bin:$HOME/.cargo/bin"
set -x EDITOR hx
set -x PAGER less
set -x LESS "-iMSx4 -FX -R"
set -x FZF_DEFAULT_COMMAND 'rg --files'
set -x COLORTERM truecolor

alias open 'xdg-open'
alias cs 'rg'
