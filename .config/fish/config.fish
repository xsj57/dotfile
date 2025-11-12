if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source

# Set up fzf key bindings

if command -q fzf
    fzf --fish | source
end

set -gx PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx YAZI_IMAGE_ADAPTER kitty

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

export EDITOR=nvim
set -gx NVM_DIR ~/.nvm


