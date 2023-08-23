[[ $(uname -a) =~ "Darwin" ]] && echo "MacOS detected, loading homebrew"
[[ $(uname -a) =~ "Darwin" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
