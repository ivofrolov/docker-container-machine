# Docker Container Machine

A simple setup to run docker inside macos container machine.

## How to use

Generate new authentication key for SSH.

``` shell
ssh-keygen -t ed25519 -C "$USER@docker.machine" -f ~/.ssh/docker_machine_id_ed25519
```

Adjust SSH configuration.

``` shell
cat >> ~/.ssh/config <<EOF

Host docker.machine
    HostName docker.machine
    IdentityFile ~/.ssh/docker_machine_id_ed25519
    StrictHostKeyChecking=no
    UserKnownHostsFile /dev/null
    ControlMaster auto
    ControlPath ~/.ssh/control-%C
    ControlPersist yes
EOF
```

Create docker context to connect with a dockerd daemon on container machine using SSH[^1].

``` shell
docker context create --docker host=ssh://docker.machine docker-machine

docker context use docker-machine
```

Build and run container machine[^2] from [Containerfile](Containerfile).

``` shell
# start container services
container system start

# create a local DNS domain for machines
sudo container system dns create machine

# build machine image
container build --build-arg authorized_keys=$(cat ~/.ssh/docker_machine_id_ed25519.pub) -t local/docker-machine:latest .

# create container machine and boot it
container machine create --name docker local/docker-machine

# delete builder container if not needed anymore
container builder delete --force
```

Check everything works fine.

``` shell
docker run hello-world
```

[^1]: https://docs.docker.com/engine/security/protect-access/
[^2]: https://github.com/apple/container/blob/main/docs/container-machine.md
