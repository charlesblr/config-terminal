#!/bin/bash

# install HomeBrew 
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh

# install git
brew install git 

# install K8S-related tools
brew install kubectl
brew install kube-ps1 # to show kubernetes contexts and namespaces in CLI
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
  tar zxvf krew.tar.gz &&
  KREW=./krew-"${OS}_${ARCH}" &&
  "$KREW" install krew
)
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
kubectl krew install ctx
kubectl krew install ns

# install aws-cli
brew install awscli

# install OhMyZsh
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh

# add plugins
echo "plugins=(kube-ps1)" >> $HOME/.zshrc

# add aliases
echo "alias k='kubectl'" >> $HOME/.zshrc
echo "alias kns='kubens'" >> $HOME/.zshrc
echo "alias kx='kubectx'" >> $HOME/.zshrc

# use plugins 
PROMPT='$(kube_ps1)'$PROMPT

