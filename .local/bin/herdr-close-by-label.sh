#!/usr/bin/env bash
id=$(herdr workspace list 2>/dev/null | \
    jq -r --arg n "$1" '.result.workspaces[] | select(.label == $n) | .workspace_id' | head -1)
[[ -n $id ]] && herdr workspace close "$id" 2>/dev/null
