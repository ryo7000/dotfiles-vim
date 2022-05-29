#!/usr/bin/env bash

set -eu -o pipefail

function mk_symlink() {
    local src="${1}"
    local dst="${2}"

    if [ -e "${dst}" ]; then
        unlink "${dst}"
    fi
    ln -s "${src}" "${dst}"
    ls -l "${dst}"
}

function chk_command() {
    local command="${1}"

    if ! builtin command -v "${command}" > /dev/null; then
        echo "Not found ${command}"
    fi
}

mk_symlink "$HOME/dotfiles/vim/.vim" "$HOME/.vim"
mk_symlink "$HOME/dotfiles/vim/.vimrc" "$HOME/.vimrc"
mk_symlink "$HOME/dotfiles/vim/.gvimrc" "$HOME/.gvimrc"

mkdir -p "$HOME/.config"
mk_symlink "$HOME/dotfiles/vim/.config/efm-langserver" "$HOME/.config/efm-langserver"

chk_command efm-langserver
chk_command rg
chk_command node
