#Variables
#Get current directory
CURRENT_DIR="$(pwd)"


# Functions
# Function to set the tab name
function set_name () {
  local current_dir=$(basename "$(pwd)") # Get the name of the current directory
  echo -ne "\033]0;󰷏   $current_dir\007" # Set the tab name
}

# Add the function to the environment variable in either Zsh or Bash
if [ -n "$ZSH_VERSION" ]; then
  precmd_functions+=(set_name)
elif [ -n "$BASH_VERSION" ]; then
  PROMPT_COMMAND='set_name'
fi

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
