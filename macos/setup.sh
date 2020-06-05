#!/bin/bash
set -e # exit on error

THIS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"


ZSH_URL="https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh"
CONDA_URL="https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
BREW_URL="https://raw.githubusercontent.com/Homebrew/install/master/install"

# ZSH
echo -e "\nOh My Zsh"
if ! which zsh > /dev/null; then
  echo "Installing..."
  sh -c "$(curl -fsSL $ZSH_URL)"
else
  echo "Already Installed"
fi

# Homebrew
echo -e "\nHomebrew"
if ! which brew > /dev/null; then
  echo "Installing..."
  /usr/bin/ruby -e "$(curl -fsSL $brew_url)"
else
  echo "Already Installed"
fi

echo "Updating..."
brew update

echo "Installing Packages..."
packages=( git
	   postgresql
         )
for pkg in "${packages[@]}"; do
  if ! brew ls --versions "$pkg" > /dev/null; then
      brew install "$pkg"
  else
    echo "$pkg already installed"
  fi
done

# Miniconda
echo -e "\nMiniconda3"
if ! which conda > /dev/null; then
  echo "Installing..."
  curl -fsSL $CONDA_URL -o ~/miniconda.sh
  bash ~/miniconda.sh -b -p $HOME/miniconda
  rm ~/miniconda.sh
else
  echo "Already Installed"
fi

# Symlink Files
echo -e "\nDotfiles"
dotfiles=( .emacs.d
           .vimrc
           .zshrc
           .gitignore_global
           .gitconfig
	         .condarc
	         vscode
         )

for filename in "${dotfiles[@]}" ; do
  echo "$filename"
  filepath="$THIS_DIR/$filename"
  if [[ ! -e "$filepath" ]];
    then
      echo "$filepath does not exist"
      exit 1;
  fi

  target="$HOME/$filename"
  if [[ ! -e $target ]]; then
    echo "Symlinking $target to $filepath"
    ln -s $filepath $target
  fi
done

if [[ ! -e "$HOME/.git-credentials" ]]; then
  git config --global credential.helper store
fi

git config --global core.excludesfile "$HOME/.gitignore_global"

echo -e "\nAll done!"