#!/bin/bash
# Use this script for local testing

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd "$THISDIR"

repo_name='dotfiles'
branch='master'
output_file="../www/${repo_name}-${branch}".tar.gz

confirm () {
    local response
    local question=${1:-"Continue?"}
    while true ; do
        read -p "$question (y/n/q): " response
        [[ $response =~ ^[Yy]$ ]] && return 0
        [[ $response =~ ^[Nn]$ ]] && return 1
        [[ $response =~ ^[Qq]$ ]] && exit 100
        echo "  Invalid response: $response"
    done
    return 2
}

git status
confirm || exit 1
git commit -a || confirm || exit 1
git checkout master && git merge --no-ff develop && git checkout develop || \
    confirm || exit 1

echo "Creating archive $output_file"
git archive --format=tar.gz          \
    -o "$output_file"                \
    --prefix="${repo_name}/" $branch

cp cmds.txt ../www/
http-server ../www/

cd -