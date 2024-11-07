#!/bin/bash

# So guys I know you all are good hackers and now what to do with this link blew, so I you want to make a same tool like this you can't use this link because I am on a free version of firebase a d don't have money to buy one you can use this tool for free and if you want to make one msg me here : developer.uzair223@gmail.com ok thanks for using this.
FIREBASE_URL="https://cli-chat-4c3cc-default-rtdb.asia-southeast1.firebasedatabase.app/chat.json"

clear
echo -e "\e[1;35m
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║     ███████╗██╗██████╗ ███████╗ ██████╗██╗  ██╗ █████╗ ████╗    ║
║     ██╔════╝██║██╔══██╗██╔════╝██╔════╝██║  ██║██╔══██╗██╔██╗   ║
║     █████╗  ██║██████╔╝█████╗  ██║     ███████║███████║██║╚██╗  ║
║     ██╔══╝  ██║██╔══██╗██╔══╝  ██║     ██╔══██║██╔══██║██║ ██║  ║
║     ██║     ██║██║  ██║███████╗╚██████╗██║  ██║██║  ██║██║ ██║  ║
║     ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝ ╚═╝  ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝\e[0m"

echo -e "\e[1;36m╔════ Enter Your Name ════╗\e[0m"
read -p "║ → " username
echo -e "\e[1;36m╚════════════════════════╝\e[0m"

send_message() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local data="{\"username\":\"$username\",\"message\":\"$message\",\"timestamp\":\"$timestamp\"}"
    curl -X POST -d "$data" "$FIREBASE_URL" 2>/dev/null
}

receive_messages() {
    local previous_data=""
    
    while true; do
        clear
        echo -e "\e[1;35m╔═══════════ Chat Room ═══════════╗\e[0m"
        
        current_data=$(curl -s "$FIREBASE_URL" 2>/dev/null)
        
        if [ "$current_data" != "null" ] && [ ! -z "$current_data" ]; then
            echo "$current_data" | jq -r 'if type=="object" then to_entries | .[] | "\(.value.timestamp) \(.value.username): \(.value.message)" else empty end' 2>/dev/null | \
            while read -r line; do
                echo -e "\e[1;33m║\e[0m \e[1;32m$line\e[0m"
            done
        fi
        
        echo -e "\e[1;35m╚════════════════════════════════╝\e[0m"
        sleep 2
    done
}

receive_messages &
receiver_pid=$!

echo -e "\e[1;36m[Type 'exit' to quit]\e[0m"
while true; do
    echo -e "\e[1;34m╔════ Message ════╗\e[0m"
    read -p "║ → " message
    echo -e "\e[1;34m╚════════════════╝\e[0m"
    
    if [ "$message" = "exit" ]; then
        kill $receiver_pid 2>/dev/null
        break
    fi
    
    if [ ! -z "$message" ]; then
        send_message "$message"
    fi
done

clear
exit 0
