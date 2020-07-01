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
