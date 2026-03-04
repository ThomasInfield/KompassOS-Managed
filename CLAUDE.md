# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

KompassOS-Managed is a [BlueBuild](https://blue-build.org/) project that produces custom OCI container images for managed corporate workstations. It layers organisation-specific software and configuration on top of the [KompassOS](https://www.kompassos.nl/) base image (which itself is built on Fedora Atomic/rpm-ostree).

Builds run entirely in GitHub Actions via `blue-build/github-action`. There is no local build toolchain — all image builds are triggered by pushing to the repository or can be manually triggered via `workflow_dispatch`.

## Repository Structure

- `recipes/` — BlueBuild recipe YAML files. Each recipe defines a distinct image variant (e.g. HWE, NVIDIA). The build matrix in `.github/workflows/build.yml` lists which recipes to build.
  - `common-dnf.yml` — shared DNF module: packages to install across all variants.
  - `common-files.yml` — shared files module: copies `files/system/` into the image root.
  - `recipe-hwe.yml` — variant for HWE (Hardware Enablement) base image.
  - `recipe-nvidia.yml` — variant for NVIDIA base image.
- `files/system/` — files placed into the image root at build time (maps to `/`). Add files under `etc/` or `usr/` mirroring their final path in the OS.
- `files/scripts/` — build-time shell scripts. Scripts must use `set -oue pipefail` and are referenced from recipe modules to run during image build.
- `modules/` — custom BlueBuild modules (currently empty placeholder).
- `cosign.pub` — public key for verifying signed image releases.

## Key Conventions

- Each recipe YAML references `from-file:` includes for shared module lists (`common-dnf.yml`, `common-files.yml`), then appends variant-specific modules (e.g. `signing`).
- The `signing` module must always be the last module in a recipe — it sets up cosign policy for the published image.
- Base images come from `ghcr.io/l0g0ff/kompassos-dx-hwe` (HWE) and `ghcr.io/l0g0ff/kompassos-dx-hwe-nvidia` (NVIDIA), both pinned to `latest`.
- RPM packages hosted as GitHub Release assets (external `.rpm` URLs) are installed via the `dnf` module with direct URLs.
- The build runs daily at 07:00 UTC (20 minutes after upstream ublue images build) to pick up base image updates automatically.
- Markdown-only changes do not trigger a rebuild (`paths-ignore: "**.md"`).
- `cosign.key` and `cosign.private` are gitignored; the signing secret is stored as `SIGNING_SECRET` in GitHub Actions secrets.

## Adding Packages

Add package names or RPM URLs under `modules[].install.packages` in `recipes/common-dnf.yml`.

## Adding System Files

Place files under `files/system/` mirroring their target path in the OS (e.g. `files/system/etc/someconfig` → `/etc/someconfig`). The `common-files.yml` module handles copying automatically.

## Adding a New Recipe Variant

1. Create `recipes/recipe-<variant>.yml` following the pattern of existing recipes.
2. Add the new filename to the `matrix.recipe` list in `.github/workflows/build.yml`.
