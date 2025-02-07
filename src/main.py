from fastapi import FastAPI
import libvirt

conn = None

app = FastAPI()

@app.get("/")
async def root():
    return { "message": "Hello World" }

@app.get("/connect")
async def connect():
    try:
        conn = libvirt.open('qemu:///system')
        if conn == None:
            return 'Failed to open connection to qemu:///system'
        else:
            return 'Connected to libvirt'
    except:
        return 'Failed to open connection to qemu:///system'

@app.get("/list")
async def getList():
    try:
        conn = libvirt.open('qemu:///system')
        domains = conn.listAllDomains(0)
        if len(domains) != 0:
            for domain in domains:
                print('Domain %s (ID %s) is %s' % (domain.name(), domain.ID(), 'running' if domain.isActive() else 'inactive'))
        else:
            return 'No active domains'
    except:
        return 'false'
    
xml = """
<domain type='qemu'>
  <name>SampleVM</name>
  <memory unit='KiB'>1048576</memory>
  <vcpu placement='static'>1</vcpu>
  <os>
    <type arch='x86_64' machine='pc-i440fx-2.9'>hvm</type>
    <boot dev='hd'/>
  </os>
  <devices>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/var/lib/libvirt/images/sample.qcow2'/>
      <target dev='vda' bus='virtio'/>
    </disk>
    <interface type='network'>
      <mac address='52:54:00:01:02:03'/>
      <source network='default'/>
      <model type='virtio'/>
    </interface>
  </devices>
</domain>
"""
@app.get("/add-vm")
async def addVM():
    conn = libvirt.open('qemu:///system')
    domain = conn.createXML(xml, 0)
    if domain == None:
        return 'Failed to create a domain from the XML definition.'
    else:
        return 'Guest has booted successfully.'

@app.get("/control/{control_type}")
async def controlVM(control_type: str):
    conn = libvirt.open('qemu:///system')
    domain = conn.lookupByName('SampleVM')
    # Запуск VM
    if control_type == 'create' and not domain.isActive():
        domain.create()

    # Остановка VM
    if control_type == 'stop' and domain.isActive():
        domain.shutdown()

    # Перезагрузка VM
    if control_type == 'reboot' and domain.isActive():
        domain.reboot()

@app.get('/getCapabilities')
async def netStat():
    conn = libvirt.open('qemu:///system')
    result = ''
    if conn == None:
        return 'Failed to open connection to qemu:///system'

    caps = conn.getCapabilities()
    result = 'Capabilities:\n'+caps

    conn.close()

    return result