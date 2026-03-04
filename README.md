# KompassOS-Managed &nbsp; [![bluebuild build badge](https://github.com/thomasinfield/kompassos-managed/actions/workflows/build.yml/badge.svg)](https://github.com/thomasinfield/kompassos-managed/actions/workflows/build.yml)

KompassOS-Managed is the corporate variant of [KompassOS](https://www.kompassos.nl/), an immutable Linux desktop built on Fedora Atomic. It extends KompassOS with organisation-specific software and configuration required for managed workstations.

> [!NOTE]
> **Looking for KompassOS for personal use?**
> This image is intended for managed corporate environments and includes organisation-specific software that is unlikely to be useful outside of that context. If you are looking for a clean KompassOS experience without the extras, please visit [kompassos.nl](https://www.kompassos.nl/) instead.

## What is different from KompassOS?

KompassOS-Managed builds on top of KompassOS and adds tooling and configuration specific to managed workstations within the organisation. This may include company-specific software that is not relevant to general users. The base KompassOS experience is preserved; the additions are layered on top.

## Installation

KompassOS-Managed is designed to be used as a rebase target from an existing KompassOS installation. **You must have KompassOS installed first.**

### Step 1 — Install KompassOS

Visit [kompassos.nl](https://www.kompassos.nl/) and follow the installation instructions to get a working KompassOS system.

### Step 2 — Rebase to KompassOS-Managed

Once you have KompassOS running, open a terminal and run the following commands to rebase to the managed image.

First, rebase to the unsigned image to install the correct signing keys and policies:

```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/thomasinfield/kompassos-managed:latest
```

Reboot to apply the changes:

```bash
systemctl reboot
```

After rebooting, rebase to the signed image:

```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/thomasinfield/kompassos-managed:latest
```

Reboot once more to complete the installation:

```bash
systemctl reboot
```

Your system is now running KompassOS-Managed. The `latest` tag always points to the most recent build and will follow the Fedora version pinned in `recipe.yml`, so you will not be automatically moved to a new major Fedora release.

## Verification

Images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). To verify the signature, download the `cosign.pub` file from this repository and run:

```bash
cosign verify --key cosign.pub ghcr.io/thomasinfield/kompassos-managed
```
