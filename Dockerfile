###########
# LIBVIRT #
###########
FROM debian:latest

# Устанавливаем зависимости
RUN apt update && apt install -y \
    libvirt-daemon \
    libvirt-daemon-system \
    libvirt-clients \
    qemu-kvm \
    bridge-utils \
    net-tools \
    iputils-ping \
    python3 \
    python3-pip \
    bash \
    make \
    build-essential libssl-dev libffi-dev python3-dev \
    python3-venv \
    pkg-config \
    libvirt-dev \
    nginx \
    vim \
    openssh-server \
    gedit \
    xfce4 \
    dbus-x11 \
    gdm3 \
    virt-manager \
    sudo \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /libvirt-container

COPY . /libvirt-container

RUN cd /libvirt-container/backend && python3 -m venv .venv && . .venv/bin/activate && pip install --no-cache-dir --upgrade -r /libvirt-container/backend/requirements.txt

RUN echo 'root:1' | chpasswd

RUN useradd -m -s /bin/bash user && \
    echo 'user:1' | chpasswd

RUN usermod -aG sudo user

EXPOSE 8080
EXPOSE 2211

# prod
# CMD bash -c "libvirtd -d" && cd /libvirt-container/backend && . ./.venv/bin/activate && fastapi run ./src/app.py
# dev
CMD bash -c "libvirtd -d & service ssh start" && cd /libvirt-container/backend && . ./.venv/bin/activate && fastapi run ./src/app.py --reload