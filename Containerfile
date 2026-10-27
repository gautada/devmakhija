ARG DEBIAN_VERSION=13.7
ARG HERMES_VERSION=0.21.5


FROM docker.io/gautada/hermes:${HERMES_VERSION}

# ╭――――――――――――――――――╮
# │ METADATA         │
# ╰――――――――――――――――――╯
LABEL org.opencontainers.image.title="devmakhija"
LABEL org.opencontainers.image.description="A specific agent harness: Dev MAkhija - CICD Engineer"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/gautada/devmakhija"
LABEL org.opencontainers.image.source="https://github.com/gautada/devmakhija"
LABEL org.opencontainers.image.license="Liscense"

# ╭――――――――――――――――――╮
# │ PACKAGES         │
# ╰――――――――――――――――――╯
# hadolint ignore=DL3016
RUN apt-get update \
 && apt-get --yes --no-install-recommends upgrade \
#  && apt-get install --yes --no-install-recommends 
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# ╭――――――――――――――――――――╮
# │ USER               │
# ╰――――――――――――――――――――╯
# Rename the base user to this container user.
# Follows the same pattern as other gautada containers.
ARG OLDUSER=hermes
ARG USER=dev
RUN /usr/sbin/usermod -l $USER $OLDUSER \
 && /usr/sbin/usermod -d /home/$USER -m $USER \
 && /usr/sbin/groupmod -n $USER $OLDUSER \
 && PASSWORD="$(openssl rand -base64 32 | tr -dc 'A-Za-z0-9' | head -c 24)" \
 && printf '%s:%s\n' "$USER" "$PASSWORD" | /usr/sbin/chpasswd

# ╭――――――――――――――――――――╮
# │ APPLICATION        │
# ╰――――――――――――――――――――╯
WORKDIR /home/${USER}
RUN ln -fsv /mnt/volumes/configuration/_gitconfig .gitconfig
# COPY mnt/volumes/configuration/podman-connections.json /mnt/volumes/configuration/podman-connections.json
# WORKDIR /home/${USER}/.config/containers
# RUN ln -fsv /mnt/volumes/configuration/podman-connections.json \
#            podman-connections.json

# ╭――――――――――――――――――――╮
# │ VERIFY             │
# ╰――――――――――――――――――――╯
# hadolint ignore=DL3059
# RUN podman --version && podman --remote system connection list

# ╭――――――――――――――――――――╮
# │ CONFIG             │
# ╰――――――――――――――――――――╯
WORKDIR /home/${USER}
RUN chown -R ${USER}:${USER} /home/${USER}
