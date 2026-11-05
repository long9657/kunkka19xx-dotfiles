#!/usr/bin/env bash
# KDE Plasma 6 (Wayland) desktop settings for my Linux machine
# safe to re-run
set -euo pipefail

# caps lock -> ctrl (use ctrl:swapcaps to swap them instead)
kwriteconfig6 --file kxkbrc --group Layout --key ResetOldOptions true
kwriteconfig6 --file kxkbrc --group Layout --key Options ctrl:nocaps
busctl --user emit /Layouts org.kde.keyboard reloadConfig

# auto hide the taskbar (other values: none, dodgewindows, windowsgobelow)
busctl --user call org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell evaluateScript s \
    "panels().forEach(p => p.hiding = 'autohide')" >/dev/null

# vietnamese input: fcitx5 + bamboo (packages come from arch.sh), ctrl+space to toggle
if command -v fcitx5 >/dev/null; then
    # kwin starts fcitx5 as the wayland input method (= System Settings > Keyboard > Virtual Keyboard)
    kwriteconfig6 --file kwinrc --group Wayland --key InputMethod /usr/share/applications/org.fcitx.Fcitx5.desktop
    busctl --user call org.kde.KWin /KWin org.kde.KWin reconfigure

    # only XWayland apps need an env var; native wayland apps talk to kwin directly
    mkdir -p ~/.config/environment.d
    echo "XMODIFIERS=@im=fcitx" >~/.config/environment.d/fcitx5.conf

    # input methods: english + bamboo. only written once, later changes are made in fcitx5-configtool
    if [ ! -f ~/.config/fcitx5/profile ]; then
        mkdir -p ~/.config/fcitx5
        cat >~/.config/fcitx5/profile <<'EOF'
[Groups/0]
Name=Default
Default Layout=us
DefaultIM=bamboo

[Groups/0/Items/0]
Name=keyboard-us
Layout=

[Groups/0/Items/1]
Name=bamboo
Layout=

[GroupOrder]
0=Default
EOF
    fi

    # switch english <-> vietnamese with ctrl+shift (either order, either side) instead of ctrl+space
    conf=~/.config/fcitx5/config
    touch "$conf"
    awk '
        /^\[/ { skip = ($0 == "[Hotkey/TriggerKeys]") }
        !skip
        END {
            print "[Hotkey/TriggerKeys]"
            print "0=Control+Shift_L"
            print "1=Control+Shift_R"
            print "2=Shift+Control_L"
            print "3=Shift+Control_R"
        }
    ' "$conf" >"$conf.tmp" && mv "$conf.tmp" "$conf"
    fcitx5-remote -r 2>/dev/null || true
fi

echo "done. if caps lock or fcitx5 don't work yet, log out and back in"
