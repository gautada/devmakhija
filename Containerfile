ARG DEBIAN_VERSION=13.6
ARG PI_VERSION=0.84.4


FROM docker.io/gautada/pi:${PI_VERSION}

# ╭――――――――――――――――――╮
# │ METADATA         │
# ╰――――――――――――――――――╯
LABEL org.opencontainers.image.title="dev"
LABEL org.opencontainers.image.description="A specific pi agent harness: Dev Makhija - CICD Architect."
LABEL org.opencontainers.image.url="https://hub.docker.com/r/gautada/dev"
LABEL org.opencontainers.image.source="https://github.com/gautada/dev"
LABEL org.opencontainers.image.license="Liscense"

# ╭――――――――――――――――――╮
# │ PACKAGES         │
# ╰――――――――――――――――――╯
# hadolint ignore=DL3016
RUN apt-get update \
 && apt-get upgrade --yes \
 && apt-get install -y --no-install-recommends skopeo \
    openssh-client gh \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# ╭――――――――――――――――――――╮
# │ USER               │
# ╰――――――――――――――――――――╯
# Rename the base user to this container user.
# Follows the same pattern as other gautada containers.
ARG OLDUSER=slice
ARG USER=dev
RUN /usr/sbin/usermod -l $USER $OLDUSER \
 && /usr/sbin/usermod -d /home/$USER -m $USER \
 && /usr/sbin/groupmod -n $USER $OLDUSER \
 && PASSWORD="$(openssl rand -base64 32 | tr -dc 'A-Za-z0-9' | head -c 24)" \
 && printf '%s:%s\n' "$USER" "$PASSWORD" | /usr/sbin/chpasswd

# ╭――――――――――――――――――――╮
# │ CONFIG             │
# ╰――――――――――――――――――――╯
WORKDIR /home/${USER}
RUN ln -fsv /mnt/volumes/configuration/.gitconfig .gitconfig \
 && chown -R ${USER}:${USER} /home/${USER}
