#Variables
#Get current directory
CURRENT_DIR="$(pwd)"


# Functions
set_name() {
  echo -ne "\033]0;󰷏   $(basename "$PWD")\007"
}
set_tmux_name() {
  echo -ne "\033]0;   Tmux\007"
}
preexec() {
  if [[ "$1" == tmux* ]]; then
    set_tmux_name
  fi
}
# Register the functions
preexec_functions+=(preexec)
precmd_functions+=(set_name)
chpwd_functions+=(set_name)

# Check if current directory is home to show rxfetch
if [ "$CURRENT_DIR" = "$HOME" ]; then
    if rxfetch -v ls >/dev/null 2>&1; then
        rxfetch
    else
        #echo "rxfetch is not installed"
        bash "$HOME/.reconfig/banner.sh"
    fi
fi

# Load bash_tools.sh
if [ ! -e "$HOME/.reconfig/bash_tools.sh" ]; then
    echo "bash_tools.sh not found"
fi

# Load config.sh
if [ ! -e "$HOME/.reconfig/config.sh" ]; then
    echo "config.sh not found"
fi

# Others
#Android Std
#export ANDROID_HOME=/home/troy/Android/Sdk
#Android adb
#export PATH=$PATH:/home/troy/Android/Sdk/platform-tools
#TODO: test with zcompile ~/.zshrc in case of bash ...
