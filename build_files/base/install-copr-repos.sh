#!/usr/bin/bash

set -eoux pipefail

# Add Nerd Fonts Repo
curl --retry 3 -Lo /etc/yum.repos.d/_copr_che-nerd-fonts-"$(rpm -E %fedora)".repo https://copr.fedorainfracloud.org/coprs/che/nerd-fonts/repo/fedora-"$(rpm -E %fedora)"/che-nerd-fonts-fedora-"$(rpm -E %fedora)".repo

# Podman-bootc
curl --retry 3 -Lo /etc/yum.repos.d/gmaglione-podman-bootc-fedora-"${FEDORA_MAJOR_VERSION}".repo \
    https://copr.fedorainfracloud.org/coprs/gmaglione/podman-bootc/repo/fedora-"${FEDORA_MAJOR_VERSION}"/gmaglione-podman-bootc-fedora-"${FEDORA_MAJOR_VERSION}".repo

# Add Ghostty Repo
curl --retry 3 -Lo /etc/yum.repos.d/ghostty-"$(rpm -E %fedora)".repo https://copr.fedorainfracloud.org/coprs/pgdev/ghostty/repo/fedora-"$(rpm -E %fedora)"/pgdev-ghostty-fedora-"$(rpm -E %fedora)".repo
