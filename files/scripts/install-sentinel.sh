#!/usr/bin/env bash
set -euo pipefail

# SentinelAgent's %post scriptlet is incompatible with container builds
# (requires chkconfig/update-rc.d and a running systemd). Install with
# --noscripts to skip the scriptlets, then enable the service manually.
dnf install --setopt=tsflags=noscripts -y \
    https://github.com/ThomasInfield/KompassOS-Managed/releases/download/v25.4.1.24/SentinelAgent_linux_x86_64_v25_4_1_24.rpm

systemctl enable sentinelagent
