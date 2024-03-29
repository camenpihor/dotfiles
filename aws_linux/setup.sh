#!/bin/bash
set -e # exit on error

THIS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

ZSH_URL="https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh"
CONDA_URL="http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh"
OTB_URL="https://www.orfeo-toolbox.org/packages/OTB-7.2.0-Linux64.run -O ~/OTB-7.2.0-Linux64.run"
GSUTIL_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-336.0.0-linux-x86_64.tar.gz"

# Linux Setup
echo -e "\nSetting up linux..."
sudo passwd ec2-user
sudo yum install util-linux-user -y

# ZSH
echo -e "\nInstalling Oh My Zsh"
if ! [ -d "${HOME}/.oh-my-zsh" ];
  then
    sudo yum -y install zsh
    wget $ZSH_URL -O - | zsh
    mv "$HOME/.zshrc" "$HOME/.zshrc_old"
    chsh -s $(which zsh)
  else
    echo "Oh My Zsh already installed"
fi

# Miniconda
echo -e "\nInstalling Miniconda 3"
INSTALL_FOLDER="$HOME/miniconda3"
if ! [ -d INSTALL_FOLDER ];
  then
    echo "conda appears to already be installed"
  else
    DOWNLOAD_PATH="miniconda.sh"
    wget $CONDA_URL -O ${DOWNLOAD_PATH};
    echo "Installing miniconda to ${INSTALL_FOLDER}"
    bash ${DOWNLOAD_PATH} -b -f -p ${INSTALL_FOLDER}
    rm ${DOWNLOAD_PATH}
fi

# Git
echo -e "\nInstalling git"
if git --version > /dev/null 2>&1;
  then
    echo "Git already isntalled"
  else
    sudo yum install -y git
fi

# OrfeoToolBox
echo -e "\nInstalling OrfeoToolBox"
INSTALL_FOLDER="$HOME/OTB-7.2.0-Darwin64"
if ! [ -d INSTALL_FOLDER ];
  then
    echo "OTB appears to already be installed"
  else
    DOWNLOAD_PATH="OTB-Linux64.run"
    wget $OTB_URL -O ${DOWNLOAD_PATH};
    echo "Installing OTB to ${INSTALL_FOLDER}"
    bash ${DOWNLOAD_PATH} -b -f -p ${INSTALL_FOLDER}
    rm ${DOWNLOAD_PATH}
fi

# gsutil
echo -e "\nInstalling gsutil"
INSTALL_FOLDER="$HOME/google-cloud-sdk"
if ! [ -d INSTALL_FOLDER ];
  then
    echo "gsutil appears to already be installed"
  else
    DOWNLOAD_PATH="google-cloud-sdk-336.0.0-linux-x86_64.tar.gz"
    wget $GSUTIL_URL -O ${DOWNLOAD_PATH};
    echo "Installing gsutil to ${INSTALL_FOLDER}"
    tar -xf $DOWNLOAD_PATH -C "$HOME"
    bash ${INSTALL_FOLDER}/install.sh
    bash ${INSTALL_FOLDER}/bin/gcloud init
    rm ${DOWNLOAD_PATH}
fi

# Packages
echo -e "\nInstalling some packages"
PACKAGES=(
  "tmux"
)
for package in "${PACKAGES[@]}"; do
  sudo yum install -y ${package}
done


# Symlink Files
echo -e "\nSymlinking some files"
FILES_TO_LINK=(
  ".vimrc"
  ".zshrc"
  ".gitignore_global"
  ".gitconfig"
  ".condarc"
)
for filename in "${FILES_TO_LINK[@]}"; do
  file="${THIS_DIR}/${filename}"
  if ! [ -f "${file}" ];
    then
      echo "${file} does not exist!  Exiting..."
      exit 1;
  fi

  target="${HOME}/${filename}"
  if ! [ -f "${target}" ];
    then
      echo "Making symlink for $file"
      ln -s "${file}" "${target}";
    else
      echo "${target} already exists"
  fi
done

cp "${THIS_DIR}/.gitconfig" "${HOME}/.gitconfig"

echo -e "\nAll done!"
