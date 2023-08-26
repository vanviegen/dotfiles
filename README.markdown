# Van Viegen's dotfiles

## What's this?

These are the configuration files and an install script that I like to use on every Linux computer I have access to. It features:

- The `zsh` shell, configured with a comfortable set of plugins.
- Autostarting `tmux` terminal multiplexer. Common keys are: `ctrl-a c` (create window), `ctrl-a n` (next window), `ctrl-a p` (previous window), `ctrl-a |` (vertical split), `ctrl-a -` (horizontal split), `ctrl-a <arrow>` (move to split).
- `helix`, a modern modal editor (https://helix-editor.com/)
- `br`, a nice tool to navigate directories (https://github.com/Canop/broot)
- `rg <term>` for doing a ripgrep text search in the current directory and all subdirectories.
- `S <cmd>` to run a command as root. Or `S :<user> <cmd>` to run a command as a certain user. You need to be in `/etc/sudoers` for this.
- Various other configurations and scripts you'll probably never need. :-)

## Installing

On a Debian/Ubuntu/Manjaro/Arch box, run:

```sh
git clone https://github.com/vanviegen/dotfiles.git ~/.dotfiles && ~/.dotfiles/install
```

This will download the repository to `~/.dotfiles`, and create symlinks from your home dir pointing at files in the `~/.dotfiles` dir. It will also ask your OS package manager to install a couple of packages, if they aren't installed yet.

## Updating

In `~/.dotfiles` do a `git pull` followed by an `./install`. The latter will cause new symlinks to be created and stale symlinks to be removed from your home dir. Additionally, it will install any newly required OS packages.

## Forking

If you want to use these dotfiles as a base for your own CLI configurations, create a fork, and clone from your fork instead. If you're not me, the first thing you'll want to do is set your name and email address in `git/gitconfig.symlink`.

## Customizing

Everything's built around topic areas. If you're adding a new area to your forked dotfiles — say, "Java" — you can simply add a `java` directory and put files in there. Anything with an extension of `.symlink` will get symlinked into `$HOME` (but with a `.` prefixed and without the `.symlink` suffix) when you run `~/.dotfiles/install`. Double underscores (`__`) are replaced by a slash (`/`), allowing you to place symlinks inside directories. For example `config__helix.symlink` would be symlinked to `~/.config/helix`.

The `bin/` directory can be used to place random scripts, as it is added to your path.
