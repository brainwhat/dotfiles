# Standalone tools such as Herdr, Codex, and Claude install here on both
# macOS and Linux.
fish_add_path "$HOME/.local/bin"

# Nix installs user-profile commands here. The directory is absent on hosts
# where Nix is not installed, so checking it keeps this config portable.
if test -d "$HOME/.nix-profile/bin"
    fish_add_path "$HOME/.nix-profile/bin"
end

if status is-interactive
    # Suppress the "Welcome to fish..." startup greeting.
    set -g fish_greeting

    # Keep conveniences host-specific: each one exists only when its backing
    # command is installed on that host.
    if command -q yazi
        function y
            set tmp (mktemp -t "yazi-cwd.XXXXXX")
            yazi $argv --cwd-file="$tmp"
            if read -z cwd <"$tmp"; and test -n "$cwd"; and test "$cwd" != "$PWD"
                builtin cd -- "$cwd"
            end
            rm -f -- "$tmp"
        end
    end

    command -q pbcopy; and alias copypath='pwd | pbcopy'
    command -q kubectl; and alias k=kubectl
    command -q python3; and alias python=python3
    command -q eza; and alias ls=eza
    command -q bat; and alias cat=bat

    if command -q nvim
        alias vim=nvim
        alias vi=nvim
        set -gx EDITOR nvim
    end

    if command -q zoxide
        zoxide init fish | source
    end
end
