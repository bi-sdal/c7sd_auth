create_link() {
    local target=$1
    local link=$2
    ln -sf $target $link
}

main() {
    if [[ -h "/home/$USER/sdal" ]]; then
        unlink /home/$USER/sdal;
    fi

    create_link /home/sdal /home/$USER/sdal
}
main
