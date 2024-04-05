[[ $(uname -a) =~ "Darwin" ]] && echo "MacOS detected, loading homebrew"
[[ $(uname -a) =~ "Darwin" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Created by `pipx` on 2023-12-15 22:34:04
export PATH="$PATH:/Users/bryan/.local/bin"
