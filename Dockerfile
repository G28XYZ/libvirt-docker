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
    && rm -rf /var/lib/apt/lists/*

WORKDIR /libvirt-container

COPY . /libvirt-container

RUN cd /libvirt-container/backend && python3 -m venv .venv && . .venv/bin/activate && pip install --no-cache-dir --upgrade -r /libvirt-container/backend/requirements.txt

EXPOSE 8080

# prod
# CMD bash -c "libvirtd -d" && cd /libvirt-container/backend && . ./.venv/bin/activate && fastapi run ./src/app.py
# dev
CMD bash -c "libvirtd -d" && cd /libvirt-container/backend && . ./.venv/bin/activate && fastapi run ./src/app.py --reload