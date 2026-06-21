FROM debian:stable

ENV container container

ARG authorized_keys
RUN echo ${authorized_keys} > /authorized_keys

RUN apt-get update && apt-get install -y --no-install-recommends \
    init \
    dbus \
    systemd \
    openssh-server \
    ca-certificates

ADD docker.asc /etc/apt/keyrings/docker.asc
RUN cat > /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
RUN apt-get update && apt-get install -y --no-install-recommends \
    docker-ce docker-ce-cli

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN >/etc/machine-id
RUN >/var/lib/dbus/machine-id

RUN sed -i -e 's/^#Storage=auto$/Storage=volatile/' /etc/systemd/journald.conf
RUN systemctl set-default multi-user.target
RUN systemctl mask \
    dev-hugepages.mount \
    sys-fs-fuse-connections.mount \
    systemd-tmpfiles-setup.service \
    systemd-modules-load.service \
    console-getty.service

ADD --chmod=+x create-user.sh /etc/machine/create-user.sh
