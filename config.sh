#!/bin/bash

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

# install helmswitcher
brew install tokiwong/tap/helm-switcher

# install aws-related tools
brew install awscli
brew install aws-iam-authenticator

# install OhMyZsh
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh

# add and configure plugin
echo "plugins=(kube-ps1)" >> $HOME/.zshrc
echo "PROMPT='$(kube_ps1)'$PROMPT" >> $HOME/.zshrc

# add aliases
echo "alias k='kubectl'" >> $HOME/.zshrc
echo "alias kns='kubens'" >> $HOME/.zshrc
echo "alias kx='kubectx'" >> $HOME/.zshrc
