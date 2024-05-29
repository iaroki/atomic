#!/bin/sh

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

RPMFUSION_MIRROR_RPMS="https://mirrors.rpmfusion.org"
if [ -n "${RPMFUSION_MIRROR}" ]; then
    RPMFUSION_MIRROR_RPMS=${RPMFUSION_MIRROR}
fi

curl -Lo /tmp/rpms/rpmfusion-free-release-${RELEASE}.noarch.rpm ${RPMFUSION_MIRROR_RPMS}/free/fedora/rpmfusion-free-release-${RELEASE}.noarch.rpm
curl -Lo /tmp/rpms/rpmfusion-nonfree-release-${RELEASE}.noarch.rpm ${RPMFUSION_MIRROR_RPMS}/nonfree/fedora/rpmfusion-nonfree-release-${RELEASE}.noarch.rpm

rpm-ostree install \
    /tmp/rpms/*.rpm \
    fedora-repos-archive

if [[ "${FEDORA_MAJOR_VERSION}" -ge 39 ]]; then
    # note: this is done before single mirror hack to ensure this persists in image and is not reset
    echo "Enable rpmfusion-(non)free-updates-testing with low priority for Fedora ${FEDORA_MAJOR_VERSION}"
    sed -i '0,/enabled=0/{s/enabled=0/enabled=1\npriority=110/}' /etc/yum.repos.d/rpmfusion-*-updates-testing.repo
fi

# after F41 launches, bump to 42
if [[ "${FEDORA_MAJOR_VERSION}" -ge 41 ]]; then
    # note: this is done before single mirror hack to ensure this persists in image and is not reset
    # pre-release rpmfusion is in a different location
    sed -i "s%free/fedora/releases%free/fedora/development%" /etc/yum.repos.d/rpmfusion-*.repo
fi

if [ -n "${RPMFUSION_MIRROR}" ]; then
    # force use of single rpmfusion mirror
    echo "Using single rpmfusion mirror: ${RPMFUSION_MIRROR}"
    sed -i.bak "s%^metalink=%#metalink=%" /etc/yum.repos.d/rpmfusion-*.repo
    sed -i "s%^#baseurl=http://download1.rpmfusion.org%baseurl=${RPMFUSION_MIRROR}%" /etc/yum.repos.d/rpmfusion-*.repo
fi

# hack in missing repos
curl -Lo /etc/yum.repos.d/keyd.repo https://copr.fedorainfracloud.org/coprs/alternateved/keyd/repo/fedora-40/alternateved-keyd-fedora-40.repo
curl -Lo /etc/yum.repos.d/nerd-fonts.repo https://copr.fedorainfracloud.org/coprs/che/nerd-fonts/repo/fedora-40/che-nerd-fonts-fedora-40.repo
curl -Lo /etc/yum.repos.d/lazygit.repo https://copr.fedorainfracloud.org/coprs/totalfreak/lazygit/repo/fedora-40/totalfreak-lazygit-fedora-40.repo
curl -Lo /etc/yum.repos.d/glow.repo https://copr.fedorainfracloud.org/coprs/tokariew/glow/repo/fedora-40/tokariew-glow-fedora-40.repo

# run common packages script
/tmp/packages.sh

if [ -n "${RPMFUSION_MIRROR}" ]; then
    # reset forced use of single rpmfusion mirror
    echo "Revert from single rpmfusion mirror: ${RPMFUSION_MIRROR}"
    rename -v .repo.bak .repo /etc/yum.repos.d/rpmfusion-*repo.bak
fi
