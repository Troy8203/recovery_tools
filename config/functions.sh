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

