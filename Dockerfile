FROM ubuntu:latest

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
    && rm -rf /var/lib/apt/lists/*

WORKDIR /libvirt-container

COPY . /libvirt-container

RUN pip install --no-cache-dir --upgrade -r /libvirt-container/requirements.txt --break-system-packages

RUN libvirtd -d

EXPOSE 18080

CMD ["fastapi", "run", "/libvirt-container/src/main.py", "--port", "80"]