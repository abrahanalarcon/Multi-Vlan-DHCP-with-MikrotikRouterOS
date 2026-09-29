# ==================================================
# ROUTER A
# VLAN 100 / 200 / 300
# ==================================================


/interface vlan
add interface=ether2 name=vlan100 vlan-id=100 
add interface=ether2 name=vlan200 vlan-id=200 
add interface=ether2 name=vlan300 vlan-id=300 

/ip address
add address=172.31.100.1/24  interface=vlan100 comment="Gateway VLAN 100"
add address=172.31.200.1/24  interface=vlan200 comment="Gateway VLAN 200"
add address=172.31.30.1/24  interface=vlan300 comment="Gateway VLAN 300"

/ip address
add address=10.11.0.1/30  interface=ether1 comment="Hacia-ISP"
add address=10.20.0.2/30 interface=ether3 comment="Hacia-Router-B"

/ip pool
add name=pool100 ranges=172.31.100.10-172.31.100.100
add name=pool200 ranges=172.31.200.10-172.31.200.100
add name=pool300 ranges=172.31.30.10-172.31.30.100

/ip dhcp-server
add name=dhcp100  interface=vlan100 address-pool=pool100
add name=dhcp200 interface=vlan200 address-pool=pool200
add name=dhcp300 interface=vlan300 address-pool=pool300

/ip dhcp-server network
add address=172.31.100.0/24 gateway=172.31.100.1 dns-server=10.50.0.3
add address=172.31.200.0/24  gateway=172.31.200.1 dns-server=10.50.0.3
add address=172.31.300.0/24 gateway=172.31.300.1  dns-server=10.50.0.3



/ip dns
set servers=10.50.0.3 allow-remote-requests=yes

/ip firewall nat

add chain=srcnat  action=accept dst-address-list=REDES-REMOTAS comment="NO NAT hacia redes Router B"
add chain=srcnat action=masquerade out-interface=ether1 comment="NAT hacia ISP"

/ip route

/
add dst-address=0.0.0.0/0 gateway=10.11.0.2 distance=1 comment="Default Route - ISP"
/
add dst-address=192.168.40.0/24 gateway=10.20.0.2 comment="VLAN 400 - Router B"
add dst-address=192.168.50.0/24 gateway=10.20.0.2 comment="VLAN 500 - Router B"
add dst-address=192.168.60.0/24 gateway=10.20.0.2 comment="VLAN 600 - Router B"

# Firewall NAT
# Primero creamos la lista de redes remotas para evitar el NAT entre sedes
/ip firewall address-list
add list=REDES-REMOTAS address=192.168.40.0/24 comment="VLAN 400 B"
add list=REDES-REMOTAS address=192.168.50.0/24 comment="VLAN 500 B"
add list=REDES-REMOTAS address=192.168.60.0/24 comment="VLAN 600 B"

/ip firewall nat
# Aceptar tráfico hacia redes remotas SIN NAT
add chain=srcnat action=accept dst-address-list=REDES-REMOTAS comment="NO NAT hacia redes Router B"
# Enmascarar todo lo que salga a Internet
add chain=srcnat action=masquerade out-interface=ether1 comment="NAT hacia ISP"