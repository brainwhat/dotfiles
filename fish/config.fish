if status is-interactive
    # Commands to run in interactive sessions can go here
end

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

alias copypath='pwd | pbcopy'
alias vim=nvim
alias vi=nvim
alias k=kubectl
alias python=python3
export EDITOR="/opt/homebrew/bin/nvim"

zoxide init fish | source

# Created by `pipx` on 2025-07-25 11:05:21
set PATH $PATH /Users/vasilijfrolov/.local/bin
fish_add_path $HOME/.local/bin
