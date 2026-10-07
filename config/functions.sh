############
# Functions
###########
# funcion backup, create a backup of a file
function backup_file() {
  FILE="$1"
  if [[ -f "$FILE" ]]; then
    if cp "$FILE" "${FILE}.backup"; then
      if [[ -f "${FILE}.backup" ]]; then
        echo " 󰸩 ${FILE}.backup created"
      else
        echo " 󱀷 ${FILE}.backup was not created"
      fi
    else
      echo " 󰩌 Failed to copy $FILE to ${FILE}.backup"
    fi
  else
    echo " 󱀶 File $FILE does not exist."
  fi
}

# Function to copy a file
copy-file() {
  if [ -f "$1" ]; then
    xclip -selection clipboard < "$1"
    echo " 󱉦 $1 File copied"
  else
    echo " 󰩌 $1 Failed to copy"
  fi
}

# Function to copy the path
copy-path() {
  pwd | xclip -selection clipboard
  echo " 󰉕 $(pwd) Path copied"
}

# Create a tmux workspace and run a command in the right pane.
tmx() {
  local cmd="$1"
  local win_name="${cmd:-Terminal}"

  case "$cmd" in
    claude) win_name=" Claude" ;;
    agy) win_name="󱍢 Antigravity" ;;
    opencode) win_name="󱞟 Opencode" ;;
    btop) win_name=" Code" ;;
  esac

  tmux rename-window " $win_name"
  tmux split-window -h
  tmux send-keys -l -- "$*"
  tmux send-keys Enter
  tmux select-pane -t 0
  tmux split-window -v
}
