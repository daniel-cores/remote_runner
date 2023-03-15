INSTALL_DIR=$HOME/.remote_runner

if [ -d "$INSTALL_DIR" ]; then
    echo "remote runner already installed. Updating..."
    cp run.sh $INSTALL_DIR/run.sh
    echo "remote runner updated."
else
    mkdir -p $INSTALL_DIR
    cp run.sh $INSTALL_DIR/run.sh
    cp config.cfg $INSTALL_DIR/config.cfg
    chmod +x $INSTALL_DIR/run.sh

    # add to .bashrc
    echo "source '$INSTALL_DIR/run.sh'" >> $HOME/.bashrc

    echo "remote runner installed."
fi
