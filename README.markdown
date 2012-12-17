# dotfiles van van viegen

## install

On a debian/ubuntu box, run this:

```sh
sudo apt-get install git ruby zsh tmux vim exuberant-ctags ncurses-bin pcregrep
git clone https://github.com/vanviegen/dotfiles.git ~/.dotfiles
~/.dotfiles/install
```

The `install` script creates symlinks from your home dir into the `~/.dotfiles` dir. It also installs an appropriate terminfo to use for 256 color tmux. If your default shell isn't set to `zsh` yet, it'll ask for your password in order to set it. In order for this change to take effect, you'll need to start a new login session (i.e. logout of your window manager).

## customizing

Everything is configured and tweaked within `~/.dotfiles`.

You'll want to change `git/gitconfig.symlink`, which will set you up as
committing as me. You probably don't want that.

## updating

Run the `dotfiles` script to do a `git pull` and a `~/.dotfiles/install`. Running the later will cause new symlinks into `~/.dotfiles` to be created and stale symlinks to be removed from your home dir.

## topical

Everything's built around topic areas. If you're adding a new area to your
forked dotfiles — say, "Java" — you can simply add a `java` directory and put
files in there. Anything with an extension of `.zsh` will get automatically
included into your shell. Anything with an extension of `.symlink` will get
symlinked without extension into `$HOME` when you run `~/.dotfiles/install`.

## components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your
  environment.
- **topic/\*.symlink**: Any files ending in `*.symlink` get symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `rake install`.
- **topic/\*.completion.sh**: Any files ending in `completion.sh` get loaded
  last so that they get loaded after we set up zsh autocomplete functions.

## thanks

Forked from https://github.com/holman/dotfiles

