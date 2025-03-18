#!/usr/bin/bash

set -eou pipefail

cp /ctx/packages.json /tmp/packages.json

/ctx/build_files/base/install-copr-repos.sh
/ctx/build_files/base/install-packages.sh
/ctx/build_files/base/install-bootc.sh
/ctx/build_files/shared/clean-stage.sh

ostree container commit
