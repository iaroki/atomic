# atomic desktop
Custom OCI build for Fedora Silverblue

## Origin
Based on Universal Blue project: https://github.com/ublue-os

## Configuration progress

- [x] Image build
- [ ] Dotfiles management
- [ ] Dconf management
- [ ] Packages management
- [ ] Distrobox management
- [ ] Development environment

## Local build

Build image:

```shell
sudo podman build -t system:tag .
```

Rebase system:

```shell
sudo rpm-ostree rebase ostree-unverified-image:containers-storage:localhost/system:tag
```

---
