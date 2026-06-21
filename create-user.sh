#!/bin/sh

set -e

useradd \
    -d "${CONTAINER_HOME}" --create-home \
    -s "${CONTAINER_SHELL}" \
    -g "${CONTAINER_GID}" -G docker \
    -u "${CONTAINER_UID}" "${CONTAINER_USER}"

mkdir -p "${CONTAINER_HOME}/.ssh"
mv /authorized_keys "${CONTAINER_HOME}/.ssh/authorized_keys"
chown -R "${CONTAINER_UID}:${CONTAINER_GID}" "${CONTAINER_HOME}/.ssh"

mkdir -p /etc/sudoers.d
echo "${CONTAINER_USER} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${CONTAINER_USER}"
chmod 440 "/etc/sudoers.d/${CONTAINER_USER}"
