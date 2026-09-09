#!/usr/bin/env bash

selected=$(herdr workspace list 2>/dev/null | \
    jq -r '.result.workspaces[] | .label' | fzf --no-preview)

[[ -z $selected ]] && exit 0

workspace_id=$(herdr workspace list 2>/dev/null | \
    jq -r --arg name "$selected" \
    '.result.workspaces[] | select(.label == $name) | .workspace_id' | head -1)

[[ -n $workspace_id ]] && herdr workspace focus "$workspace_id"
