export NVM_DIR="$HOME/.nvm"

install_nvm() {
  git clone https://github.com/creationix/nvm "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" origin)
  . "$NVM_DIR/nvm.sh"
}

[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" ]
