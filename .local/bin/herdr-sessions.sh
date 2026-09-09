#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$({
        find ~/dev/work ~/dev/personal -mindepth 1 -maxdepth 1 -type d
        find ~/dev/work ~/dev/personal -mindepth 3 -maxdepth 3 -type d -path '*/apps/*'
    } | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)

workspace_id=$(herdr workspace list 2>/dev/null | \
    jq -r --arg name "$selected_name" \
    '.result.workspaces[] | select(.label == $name) | .workspace_id' 2>/dev/null | head -1)

if [[ -n $workspace_id ]]; then
    herdr workspace focus "$workspace_id"
    exit 0
fi

created=$(herdr workspace create --cwd "$selected" --label "$selected_name" --no-focus 2>/dev/null)
workspace_id=$(echo "$created" | jq -r '.result.workspace.workspace_id')
default_tab_id=$(echo "$created" | jq -r '.result.tab.tab_id')
default_pane_id=$(echo "$created" | jq -r '.result.root_pane.pane_id')

herdr tab rename "$default_tab_id" vim
herdr pane run "$default_pane_id" nvim

setup_tab() {
    local label=$1 command=$2 result pane_id
    result=$(herdr tab create --workspace "$workspace_id" --cwd "$selected" --label "$label" --no-focus 2>/dev/null)
    if [[ -n "$command" ]]; then
        pane_id=$(echo "$result" | jq -r '.result.root_pane.pane_id')
        [[ -n "$pane_id" && "$pane_id" != "null" ]] && herdr pane run "$pane_id" "$command"
    fi
}

setup_tab "term" ""
setup_tab "git" "lazygit"
setup_tab "ai" "claude"

herdr workspace focus "$workspace_id"
herdr tab focus "$default_tab_id"
