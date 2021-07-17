#!/bin/bash
if grep -Fxq "set -gx PATH /home/${USER}/.local/bin /home/${USER}/go/bin /home/${USER}/.npm-packages/bin \$PATH" /home/${USER}/.config/fish/config.fish; then
    echo "Path config found, not installing"
else
    echo -e '' >> /home/${USER}/.config/fish/config.fish
    echo -e "set -gx PATH /home/${USER}/.local/bin /home/${USER}/go/bin /home/${USER}/.npm-packages/bin \$PATH" >> /home/${USER}/.config/fish/config.fish
fi
