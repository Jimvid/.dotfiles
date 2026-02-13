#!/bin/bash
set -e

VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n1)
curl -Lo /tmp/go.tar.gz "https://go.dev/dl/${VERSION}.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf /tmp/go.tar.gz
