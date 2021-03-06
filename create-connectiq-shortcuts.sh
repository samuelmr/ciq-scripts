
# Personal preferences
DEVELOPER_KEY="$HOME/garmin/developer_key.der"  # your developer key file
SHELL_RC_FILE="$HOME/.zshrc"                    # depends on your shell
DEFAULT_DEVICE="fenix5plus"                     # default simulator device
BIN_PATH="$HOME/ciq-scripts"                    # location of this package
CIQ_SHORTCUT="$HOME/connectiq"                  # convenience shortcut to SDK

# ConnectIQ SDK locations
CIQ_PATH="$HOME/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk"
CIQ_CONFIG_PATH="$HOME/Library/Application Support/Garmin/ConnectIQ/current-sdk.cfg"

# You can also set this to point to another SDK version instead of setting
# the default SDK version in the SdkManager
ln -s "$CIQ_PATH" "$CIQ_SHORTCUT" && echo "Symlinked Connect IQ SDK to '$CIQ_SHORTCUT'"

# Set $PATH and create aliases
cat << EORC >> "$SHELL_RC_FILE" && echo "Edited $SHELL_RC_FILE"
export CIQ_TARGET="$DEFAULT_DEVICE"
export CIQ_KEYFILE="$DEVELOPER_KEY"
export CIQ_HOME=\`cat "$CIQ_CONFIG_PATH"\`
export PATH=\$PATH:~/connectiq/bin:"\${CIQ_HOME}bin"
alias mc="$BIN_PATH/monkeyc.sh"
alias md="$BIN_PATH/monkeydo.sh"
alias iqbeta="$BIN_PATH/iqbeta.sh"
alias iqcompile="$BIN_PATH/iqcompile.sh"
alias iqinit="$BIN_PATH/iqinit.sh"
alias iqtest="$BIN_PATH/iqtest.sh"
alias iqdevices='ls -1 "\${CIQ_HOME}../../devices"'

EORC
