export PATH="$HOME/.npm-packages/bin:$PATH" # man 1 sh
export NODE_PATH="$HOME/.npm-packages/lib/node_modules" # man 1 node
export NPM_CONFIG_PREFIX="$HOME/.npm-packages" # man 7 npm-config
                                               # NOT man 1 or man 3
export N_PREFIX="$HOME/.npm-packages" # installs under ~/.npm-packages/n

install_node_version() {
  rm -rf "$HOME"/.npm-packages
  command npm install -g npm
  command npm install -g n
  n "$1"
  command npm install yarn
}

npm() {
  echo "Use yarn instead!"
  which yarn >/dev/null || echo 'Run `install_node_version 7.0.0` to update Node and install Yarn'
  return 1
}
