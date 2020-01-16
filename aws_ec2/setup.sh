#!/bin/bash
set -e # exit on error

THIS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

echo -e "\nInstalling Oh My Zsh"
if ! [ -d "${HOME}/.oh-my-zsh" ]; then
  sudo yum install zsh
  wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
  exec zsh

else
  echo "Oh My Zsh already installed"
fi

echo -e "\nInstalling Miniconda 3"
if conda --version > /dev/null 2>&1;
  then
    echo "conda appears to already be installed"
  else
    INSTALL_FOLDER="$HOME/miniconda3"
    if [ ! -d ${INSTALL_FOLDER} ] || [ ! -e ${INSTALL_FOLDER/bin/conda} ];
      then
        DOWNLOAD_PATH="miniconda.sh"
        wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ${DOWNLOAD_PATH};
        echo "Installing miniconda to ${INSTALL_FOLDER}"
        bash ${DOWNLOAD_PATH} -b -f -p ${INSTALL_FOLDER}
        rm ${DOWNLOAD_PATH}
      else
        echo "Miniconda already installed at ${INSTALL_FOLDER}"
    fi
fi

if ! [ -f "${HOME}/.git-credentials" ]; then
  sudo yum install git
  git config --global credential.helper store
fi

echo -e "\nSymlinking some files"
FILES_TO_LINK=(
  ".vimrc"
  ".zshrc"
  ".gitignore_global"
  ".condarc"
)
for filename in "${FILES_TO_LINK[@]}"; do
  file="${THIS_DIR}/${filename}"
  if ! [ -f "${file}" ]; then
    echo "${file} does not exist!  Exiting..."
    exit 1;
  fi

  target="${HOME}/${filename}"
  if ! [ -f "${target}" ]; then
    echo "Making symlink for $file"
    ln -s "${file}" "${target}";
  else
    echo "${target} already exists"
  fi
done

git config --global core.excludesfile "${HOME}/.gitignore_global"

echo -e "\nAll done!"
