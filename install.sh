#!/bin/zsh

# Define a function which rename a `target` file to `target.backup` if the file
# exists and if it's a 'real' file, ie not a symlink
backup() {
  target=$1
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      mv "$target" "$target.backup"
      echo "-----> Moved your old $target config file to $target.backup"
    fi
  fi
}

symlink() {
  file=$1
  link=$2
  if [ ! -e "$link" ]; then
    echo "-----> Symlinking your new $link"
    ln -s $file $link
  fi
}

# For all files `$name` in the present folder except `*.sh`, `README.md`, `settings.json`,
# and `config`, backup the target file located at `~/.$name` and symlink `$name` to `~/.$name`
for name in aliases gitconfig zshrc; do
  if [ ! -d "$name" ]; then
    target="$HOME/.$name"
    backup $target
    symlink $PWD/$name $target
  fi
done

# Refresh the current terminal with the newly installed configuration
exec zsh

exec dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal-profiles.dconf

# Download JetBrains Mono Font
wget https://download.jetbrains.com/fonts/JetBrainsMono-2.242.zip
unzip JetBrainsMono-2.242.zip
cp JetBrainsMono-2.242/fonts/ttf/JetBrainsMono-Light.ttf ~/.local/share/fonts
cp JetBrainsMono-2.242/fonts/ttf/JetBrainsMonoNL-Light.ttf ~/.local/share/fonts
cp JetBrainsMono-2.242/fonts/ttf/JetBrainsMonoNL-Regular.ttf ~/.local/share/fonts

echo "Carry on with git setup!"
