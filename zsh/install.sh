#!/bin/sh

PLUGINS_DIR=$HOME/.zsh/plugins
FUNCTIONS_DIR=$HOME/.zsh/functions

mkdir -p $PLUGINS_DIR $FUNCTIONS_DIR

cp plugins/base16-default-dark.sh $PLUGINS_DIR/
cp plugins/specialkeys.plugin.zsh $PLUGINS_DIR/
cp plugins/git.plugin.zsh $PLUGINS_DIR/
cp plugins/docker-compose.plugin.zsh $PLUGINS_DIR/

cp functions/_docker-compose $FUNCTIONS_DIR/

cp zshrc $HOME/.zshrc
