#!/usr/bin/env bash

search_term="$@"

open_firefox() {
    local url=$1

    # Check if Firefox is already running
    if pgrep -x "firefox" > /dev/null; then
        firefox -new-tab "$url" &
    else
        nohup firefox "$url" >/dev/null 2>&1 &
    fi
}

if [ -n "$search_term" ]; then
    case "$search_term" in
        "Github")
            open_firefox "https://www.github.com"
            ;;
        "Youtube")
            open_firefox "https://www.youtube.com"
            ;;
        "ChatGPT")
            open_firefox "https://www.chatgpt.com"
            ;;
        "MonkeyType")
            open_firefox "https://www.monkeytype.com"
            ;;
        "Proton - Mail")
            open_firefox "https://mail.proton.me/u/1/inbox"
            ;;
        "Proton - Drive")
            open_firefox "https://drive.proton.me/u/1"
            ;;
        "Proton - Calendar")
            open_firefox "https://calendar.proton.me/u/1"
            ;;
        *)
            open_firefox "https://duckduckgo.com/?q=$search_term"
            ;;
    esac
    exit 0
fi

echo "Github"
echo "Youtube"
echo "ChatGPT"
echo "Monkeytype"
echo "Proton - Mail"
echo "Proton - Drive"
echo "Proton - Calendar"
