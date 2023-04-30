# Van Viegen's dotfiles

## Installing

On a Debian/Ubuntu/Manjaro/Arch box, run:

```sh
git clone https://github.com/vanviegen/dotfiles.git ~/.dotfiles && ~/.dotfiles/install
```

This will download the repository to `~/.dotfiles`, and create symlinks from your home dir pointing at files in the `~/.dotfiles` dir. It will also ask your OS package manager to install a couple of packages, if they aren't installed yet. If your default shell isn't set to `fish` yet, it'll ask for your password in order to set it. For this change to take effect, you'll need to start a new login session (i.e. logout of your window manager).

## Updating

In `~/.dotfiles` do a `git pull` followed by an `./install`. The latter will cause new symlinks to be created and stale symlinks to be removed from your home dir. Additionally, it will install any newly required OS packages.

## Customizing

Everything's built around topic areas. If you're adding a new area to your forked dotfiles — say, "Java" — you can simply add a `java` directory and put files in there. Anything with an extension of `.symlink` will get symlinked into `$HOME` (but with a `.` prefixed and without the `.symlink` suffix) when you run `~/.dotfiles/install`. Double underscores (`__`) are replaced by a slash (`/`), allowing you to place symlinks inside directories. For example `config__helix.symlink` would be symlinked to `~/.config/helix`.

The `bin/` directory can be used to place random scripts, as it is added to your path.
