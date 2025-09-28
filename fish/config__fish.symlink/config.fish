if status is-interactive
    # Start tmux instead if we're not already in tmux, we're not in vscode and it's an interactive session
    if not set -q TMUX; and not set -q SUING; and not string match -q vscode $TERM_PROGRAM
        if command -v tmux >/dev/null
            exec tmux new-session -A -s $USER-main
        else
            echo "Failed to start tmux"
        end
    end

    if not set -q SUING
        set -gx DOT $HOME/.dotfiles
        set -gx PATH $DOT/bin $DOT/xbin $HOME/.local/bin $HOME/.linuxbrew/bin /home/linuxbrew/.linuxbrew/bin $PATH
    else
        set -gx DOT $SUING/.dotfiles
        set f $SUING/.sudo-env.tmp
        if test -f $f
            source $f
            rm $f
        end
    end
    if test $EUID -eq 0
        set -gx PATH $PATH /sbin /usr/sbin
    end

    # Configuration for various tools
    set -gx COLORTERM truecolor
    set -gx FZF_DEFAULT_COMMAND 'rg --files'
    set -gx LESS '-iMSx4 -FX -R'
    set -gx PAGER less
    set -gx EDITOR hx
    set -gx LS_COLORS "di=38;2;0;153;153:ln=38;2;0;166;178:so=38;2;255;116;0:pi=38;2;255;116;0:ex=38;2;0;153;153:bd=38;2;255;116;0:cd=38;2;255;116;0:su=38;2;255;116;0:sg=38;2;255;116;0:tw=38;2;255;116;0:ow=38;2;255;116;0:*.tar=38;2;255;116;0:*.tgz=38;2;255;116;0:*.arc=38;2;255;116;0:*.arj=38;2;255;116;0:*.taz=38;2;255;116;0:*.lha=38;2;255;116;0:*.lz4=38;2;255;116;0:*.lzh=38;2;255;116;0:*.lzma=38;2;255;116;0:*.tlz=38;2;255;116;0:*.txz=38;2;255;116;0:*.tzo=38;2;255;116;0:*.t7z=38;2;255;116;0:*.zip=38;2;255;116;0:*.z=38;2;255;116;0:*.dz=38;2;255;116;0:*.gz=38;2;255;116;0:*.lrz=38;2;255;116;0:*.lz=38;2;255;116;0:*.lzo=38;2;255;116;0:*.xz=38;2;255;116;0:*.zst=38;2;255;116;0:*.tzst=38;2;255;116;0:*.bz2=38;2;255;116;0:*.bz=38;2;255;116;0:*.tbz=38;2;255;116;0:*.tbz2=38;2;255;116;0:*.tz=38;2;255;116;0:*.deb=38;2;255;116;0:*.rpm=38;2;255;116;0:*.jar=38;2;255;116;0:*.war=38;2;255;116;0:*.ear=38;2;255;116;0:*.sar=38;2;255;116;0:*.rar=38;2;255;116;0:*.alz=38;2;255;116;0:*.ace=38;2;255;116;0:*.zoo=38;2;255;116;0:*.cpio=38;2;255;116;0:*.7z=38;2;255;116;0:*.rz=38;2;255;116;0:*.cab=38;2;255;116;0:*.wim=38;2;255;116;0:*.swm=38;2;255;116;0:*.dwm=38;2;255;116;0:*.esd=38;2;255;116;0:*.jpg=38;2;92;204;204:*.jpeg=38;2;92;204;204:*.mjpg=38;2;92;204;204:*.mjpeg=38;2;92;204;204:*.gif=38;2;92;204;204:*.bmp=38;2;92;204;204:*.pbm=38;2;92;204;204:*.pgm=38;2;92;204;204:*.ppm=38;2;92;204;204:*.tga=38;2;92;204;204:*.xbm=38;2;92;204;204:*.xpm=38;2;92;204;204:*.tif=38;2;92;204;204:*.tiff=38;2;92;204;204:*.png=38;2;92;204;204:*.svg=38;2;92;204;204:*.svgz=38;2;92;204;204:*.mng=38;2;92;204;204:*.pcx=38;2;92;204;204:*.mov=38;2;92;204;204:*.mpg=38;2;92;204;204:*.mpeg=38;2;92;204;204:*.m2v=38;2;92;204;204:*.mkv=38;2;92;204;204:*.webm=38;2;92;204;204:*.ogm=38;2;92;204;204:*.mp4=38;2;92;204;204:*.m4v=38;2;92;204;204:*.mp4v=38;2;92;204;204:*.vob=38;2;92;204;204:*.qt=38;2;92;204;204:*.nuv=38;2;92;204;204:*.wmv=38;2;92;204;204:*.asf=38;2;92;204;204:*.rm=38;2;92;204;204:*.rmvb=38;2;92;204;204:*.flc=38;2;92;204;204:*.avi=38;2;92;204;204:*.fli=38;2;92;204;204:*.flv=38;2;92;204;204:*.gl=38;2;92;204;204:*.dl=38;2;92;204;204:*.xcf=38;2;92;204;204:*.xwd=38;2;92;204;204:*.yuv=38;2;92;204;204:*.cgm=38;2;92;204;204:*.emf=38;2;92;204;204:*.ogv=38;2;92;204;204:*.ogx=38;2;92;204;204:*.aac=38;2;51;204;204:*.au=38;2;51;204;204:*.flac=38;2;51;204;204:*.m4a=38;2;51;204;204:*.mid=38;2;51;204;204:*.midi=38;2;51;204;204:*.mka=38;2;51;204;204:*.mp3=38;2;51;204;204:*.mpc=38;2;51;204;204:*.ogg=38;2;51;204;204:*.ra=38;2;51;204;204:*.wav=38;2;51;204;204:*.oga=38;2;51;204;204:*.opus=38;2;51;204;204:*.spx=38;2;51;204;204:*.xspf=38;2;51;204;204:"
    alias open xdg-open

    # Disable the friendly welcome message
    set fish_greeting

    # Disable prompt shortening (just /var/home instead of /v/h)
    set -g fish_prompt_pwd_dir_length 0

    # Git helper functions
    function in-git-repo
        git rev-parse --is-inside-work-tree >/dev/null 2>&1
    end

    function git-branch-name-and-repo-status
        set -l branch (git branch --show-current 2>/dev/null)
        if test -z "$branch"
            set branch (git rev-parse --short HEAD 2>/dev/null)
        end
        
        set -l status_icons ""
        
        # Check for staged changes
        if not git diff-index --quiet --cached HEAD -- 2>/dev/null
            set status_icons "$status_icons+"  # staged changes
        end
        
        # Check for unstaged modifications (working tree vs index)
        if not git diff-files --quiet 2>/dev/null
            set status_icons "$status_icons!"  # modified files
        end
        
        # Check for untracked files
        if test (count (git ls-files --others --exclude-standard 2>/dev/null)) -gt 0
            set status_icons "$status_icons?"  # untracked files
        end
        
        # If no changes, show clean status
        if test -z "$status_icons"
            set status_icons "✓"  # clean
        end
        
        echo -n "$branch $status_icons"
    end

    function fish_prompt
        echo # new line for clarity
        set_color black

        if set -q SUING
            set_color -b 5f00d7 # purple background
            echo -n ""

            set_color white
            echo -n " "(whoami)" "

            set_color 5f00d7 # purple now as foreground
        end

        if set -q SSH_CLIENT; or set -q SSH_TTY
            set_color -b $fish_color_host_remote
            echo -n ""

            set_color black
            echo -n " "(hostname)" "

            set_color $fish_color_host_remote # now as fg color
        end

        set_color -b 009999 # cyan background
        echo -n ""

        set_color 000000 # full black text
        echo -n " "(prompt_pwd)" "

        set_color 009999 # now as fg color

        if in-git-repo
            set_color -b 444444 # gray background
            echo -n ""

            set_color 009999
            echo -n " "(git-branch-name-and-repo-status)" "

            set_color 444444 # now as fg color
        end

        set_color -b black
        echo -n " "

        set_color normal
    end

    # This function starts broot and executes the command it produces, if any.
    function br
        set -l cmd_file (mktemp)
        if broot --outcmd $cmd_file $argv
            set -l cmd (cat $cmd_file)
            rm -f $cmd_file
            eval $cmd
        else
            set -l code $status
            rm -f $cmd_file
            return $code
        end
    end

    # Set the tmux title to current program/dir
    function term_set_title
        set -l max_length 20
        set -l title (string replace -r -a '[^[:print:]]' '' $argv[1])
        if test (string length $title) -gt $max_length
            set title (string sub -l $max_length $title)..
        end
        if set -q SUING
            set title (whoami)@$title
        end
        printf '\033k%s\033\\' $title
    end
    function fish_title
        if set -q argv[1]
            # preexec: set to command
            term_set_title $argv[1]
        else
            # precmd: set to pwd
            term_set_title (prompt_pwd)
        end
    end

    # Aliases for eza
    if command -v eza >/dev/null
        set eza_params --git --icons --classify --time-style=long-iso --group --color-scale all
        alias ls eza
        alias l "eza --group-directories-first $eza_params"
        alias ll "eza --all --header --long --group-directories-first $eza_params"
        alias lt "eza --all --header --long --sort=modified $eza_params"
        alias la "eza -lbhHigUmuSaB@"
        alias t "eza --tree --group-directories-first $eza_params"
    end

    if command -v flatpak >/dev/null
        # Create aliases for all flatpak commands that are not in the PATH
        for app_id in (flatpak list --app --columns=application)
            if test -n "$app_id"
                set alias_name (string lower (string split . $app_id)[-1])
                if not command -v $alias_name >/dev/null
                    abbr -a $alias_name flatpak run $app_id
                end
            end
        end
    end

    # Expand .., ..., etc to the appropriate number of cd ../
    function multicd
        echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
    end
    abbr --add dotdot --regex '^\.\.+$' --function multicd

    if test -e ~/Documents/keys/openai.key
        set -gx OPENAI_API_KEY (cat ~/Documents/keys/openai.key)
    end

    if test -e ~/Documents/keys/openrouter.key
        set -gx OPENROUTER_API_KEY (cat ~/Documents/keys/openrouter.key)
    end

    if test -f "$HOME/.cargo/env.fish"
        source "$HOME/.cargo/env.fish"
    end

    # Enable VSCode shell integration if in VSCode terminal
    if string match -q "$TERM_PROGRAM" vscode
        . (code --locate-shell-integration-path fish)
    end
end
