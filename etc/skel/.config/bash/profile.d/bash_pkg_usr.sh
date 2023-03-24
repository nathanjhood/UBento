if [ -d "$HOME/.yarn/bin" ]; then
    PATH="$HOME/.yarn/bin:$PATH"
fi

if [ -d "$HOME/.npm/bin" ]; then
    PATH="$HOME/.npm/bin:$PATH"
fi

if [ -d "$HOME/.vckpg/bin" ]; then
    PATH="$HOME/.vcpkg/bin:$PATH"
fi
