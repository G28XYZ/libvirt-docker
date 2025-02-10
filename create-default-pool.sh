# TODO - создать эндпоинт в бэке для создания пула

virsh pool-destroy default
virsh pool-undefine default

mkdir -p /test_data/kvm

virsh pool-define-as --name default --type dir --target /test_data/kvm

virsh pool-autostart default
virsh pool-build default
virsh pool-start default