if [ -f "$HOME/.npmrc" ]; then
	echo "prefix = $HOME/.npm-packages" > $HOME/.npmrc
fi
PATH="$(npm prefix -g)/bin:$PATH"
