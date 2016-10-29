export PATH="$HOME/.npm-packages/bin:$PATH" # man 1 sh
export NODE_PATH="$HOME/.npm-packages/lib/node_modules" # man 1 node
export NPM_CONFIG_PREFIX="$HOME/.npm-packages" # man 7 npm-config
                                               # NOT man 1 or man 3
export N_PREFIX="$HOME/.npm-packages" # installs under ~/.npm-packages/n

install_node_version() {
  mv "$HOME/.npm-packages" "$HOME/.npm-packages-$(node -v)"
  echo "The previous versions of your NPM packages have moved. They are now"
  echo "accessible at: $HOME/.npm-packages-$(node -v)"
  command npm install -g npm
  command npm install -g n
  n "$1"
  command npm install yarn
}

npm() {
  echo "Use yarn instead!" >&2
  command -v yarn >/dev/null || (
    echo 'Run `install_node_version latest` to update Node and install Yarn' >&2
    echo 'You can also specify an alias, such as `lts`, `latest`, etc.' >&2
  )
  return 1
}
