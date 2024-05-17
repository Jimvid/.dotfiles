#!/usr/bin/env bash

search_term="$@"

if [ -n "$search_term" ]; then
    if [ "$search_term" = "Github" ]; then
        firefox -new-tab -url "https://www.github.com"
        exit 0
    elif [ "$search_term" = "Youtube" ]; then
        firefox -new-tab -url "https://www.youtube.com"
        exit 0
    elif [ "$search_term" = "ChatGPT" ]; then
        firefox -new-tab -url "https://www.chatgpt.com"
        exit 0
    elif [ "$search_term" = "MonkeyType" ]; then
        firefox -new-tab -url "https://www.monkeytype.com"
        exit 0
    elif [ "$search_term" = "Proton - Mail" ]; then
        firefox -new-tab -url "https://mail.proton.me/u/1/inbox"
        exit 0
    elif [ "$search_term" = "Proton - Mail" ]; then
        firefox -new-tab -url "https://mail.proton.me/u/1/inbox"
        exit 0
    elif [ "$search_term" = "Proton - Drive" ]; then
        firefox -new-tab -url "https://drive.proton.me/u/1"
        exit 0
    elif [ "$search_term" = "Proton - Calendar" ]; then
        firefox -new-tab -url "https://calendar.proton.me/u/1"
        exit 0
    else
        firefox -new-tab -url "https://duckduckgo.com/?q=$search_term"
        exit 0
    fi
fi

echo "Github"
echo "Youtube"
echo "ChatGPT"
echo "Monkeytype"
echo "Proton - Mail"
echo "Proton - Drive"
echo "Proton - Calendar"
