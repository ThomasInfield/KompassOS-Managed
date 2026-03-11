#!/usr/bin/env bash
set -euo pipefail

# Add Microsoft GPG key and RHEL 9 repository
rpm --import https://packages.microsoft.com/keys/microsoft.asc
curl -o /etc/yum.repos.d/microsoft-rhel9-prod.repo \
    https://packages.microsoft.com/yumrepos/microsoft-rhel9.0-prod/config.repo

# java-11-openjdk is required by microsoft-identity-broker but unavailable in
# Fedora 43 repositories. Packages sourced from Fedora 41 koji:
# https://kojipkgs.fedoraproject.org/packages/java-11-openjdk/11.0.29.0.7/1.fc41/x86_64/
# --nogpgcheck is required because microsoft-identity-diagnostics has no digest
# in the Microsoft repo metadata, causing DNF5 to reject the transaction.
dnf install -y --nogpgcheck \
    https://github.com/ThomasInfield/KompassOS-Managed/releases/download/managed-deps/java-11-openjdk-headless-11.0.29.0.7-1.fc41.x86_64.rpm \
    https://github.com/ThomasInfield/KompassOS-Managed/releases/download/managed-deps/java-11-openjdk-11.0.29.0.7-1.fc41.x86_64.rpm \
    microsoft-identity-broker \
    intune-portal
