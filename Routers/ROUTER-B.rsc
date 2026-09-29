# ==================================================
# ROUTER B
# VLAN 400 / 500 / 600
# ==================================================


/interface vlan
add interface=ether2 name=vlan400 vlan-id=400 
add interface=ether2 name=vlan500 vlan-id=500
add interface=ether2 name=vlan600 vlan-id=600

/ip address
add address=192.168.40.1/24 interface=vlan400
add address=192.168.50.1/24 interface=vlan500
add address=192.168.60.1/24 interface=vlan600

/ip address
add address=10.1.1.6/30 interface=ether3 comment="Hacia ISP"
add address=10.20.0.1/30 interface=ether1 comment="Hacia Router A"

/ip pool
add name=pool400 ranges=192.168.40.10-192.168.40.100
add name=pool500 ranges=192.168.50.10-192.168.50.100
add name=pool600 ranges=192.168.60.10-192.168.60.100

/ip dhcp-server
add name=dhcp400  interface=vlan400 address-pool=pool400 
add name=dhcp500  interface=vlan500 address-pool=pool500 
add name=dhcp600  interface=vlan600 address-pool=pool600 

/ip dhcp-server network
add address=192.168.40.0/24  gateway=192.168.40.1 dns-server=10.50.0.3
add address=192.168.50.0/24  gateway=192.168.50.1 dns-server=10.50.0.3
add address=192.168.60.0/24 gateway=192.168.60.1  dns-server=10.50.0.3

/ip dns
set servers=10.50.0.3 allow-remote-requests=yes

/ip firewall nat
add chain=srcnat action=accept dst-address=172.31.0.0/16 comment="NO NAT hacia redes Router A"
add chain=srcnat action=masquerade out-interface=ether3 comment="NAT hacia ISP"

/ip route
# Ruta por defecto hacia el ISP
add dst-address=0.0.0.0/0 gateway=10.1.1.5 distance=1 comment="Default Route - ISP"
add dst-address=172.31.100.0/24 gateway=10.20.0.1 comment="VLAN 100 - Router A"
add dst-address=172.31.200.0/24 gateway=10.20.0.1 comment="VLAN 200 - Router A"
add dst-address=172.31.30.0/24 gateway=10.20.0.1 comment="VLAN 300 - Router A"



/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik