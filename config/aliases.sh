############
# ALIASES  #
###########

#Old docker list
#alias docker-list='docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}" | awk "NR==1{print \"No.\t\" \$0} NR>1{print NR-1 \"\t\" \$0}"'
alias docker-list='docker ps -a --format "{{.ID}}\t{{.Names}}\t{{.Ports}}" | awk -F"\t" "BEGIN {printf \"│ %-4s│ %-5s│ %-20s│ %-s\n\", \"󱃔 \", \"ID\", \"󰡨 NAME\", \"󰈀 PORTS\"; print \"├─────┼──────┼─────────────────────┼────────────────\"} {printf \"│ %-4d│ %-5s│ %-20s│ %-s\n\", NR, substr(\$1, 1, 5), \$2, \$3}"'
alias docker-time='docker ps -a --format "{{.ID}}\t{{.Names}}\t{{.RunningFor}}\t{{.Ports}}" | awk -F"\t" "BEGIN {printf \"│ %-4s│ %-5s│ %-20s│ %-15s│ %-s\n\", \"󱃔 \", \"ID\", \"󰡨 NAME\", \"󰔟 TIME\", \"󰈀 PORTS\"; print \"├─────┼──────┼─────────────────────┼────────────────┼────────────────\"} {printf \"│ %-4d│ %-5s│ %-20s│ %-15s│ %-s\n\", NR, substr(\$1, 1, 5), \$2, substr(\$3, 1, 15), \$4}"'
alias docker-remove='docker rm $(docker ps -qa) && echo "󰩹 Docker(s) stopped and removed"'
alias docker-start='docker start $(docker ps -qa) && echo "󰐌 Docker(s) started"'
alias docker-stop='docker stop $(docker ps -qa) && echo "󰙦 Docker(s) stopped"'
alias list='colorls -aC --sd | more -n 20'
alias listType='colorls -aCX --sd | more -n 20'
alias listAll='colorls -al --sd | more -n 20'
alias listAllTime='colorls -alt --sd | more -n 20'
alias listTime='colorls -atC --sd | more -n 20'
alias listTree='colorls -aC --sd --tree | more -n 20'
alias listTree2='colorls -aC --sd --tree=2 | more -n 20'
alias copy-text='xclip -selection clipboard && echo "󰆏 Copied to clipboard"'
alias copy-branch='echo -n $(git branch --show-current) | xclip -selection clipboard && echo " $(git branch --show-current) copied to clipboard"'
alias remove_node_modules='find ./ -type d -name 'node_modules' -exec rm -rf {} + && echo "󰩹 node_modules Folder was deleted"'

#Trash
alias sudo='sudo '
alias rm='trash'

#Files
alias open=xdg-open

#Alias of tmux
alias label_default='tmux rename-window " Terminal"'
alias label_logs='tmux rename-window "󱇗 Logs"'
alias label_backend='tmux rename-window " Backend"'
alias label_frontend='tmux rename-window "󰾰 Frontend"'
alias label_database='tmux rename-window " Database"'
alias label_test='tmux rename-window "󰙨Test"'
alias label_docs='tmux rename-window "󱞂 Docs"'
alias label_dev='tmux rename-window "  Develop"'
alias label_server='tmux rename-window "  Server"'

#Alias of task
alias listTask='cat /home/troy/.reconfig/task.txt'
