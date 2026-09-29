


/ip address
add address=10.11.0.1/30 interface=ether1 comment="WAN ISP"
add address=10.20.0.1/30 interface=ether3 comment="Enlace a Router B"


/ip route
add dst-address=0.0.0.0/0 gateway=10.11.0.2 comment="Salida a Internet"


/interface vlan

add name=vlan100 vlan-id=100 interface=ether2
add name=vlan200 vlan-id=200 interface=ether2
add name=vlan300 vlan-id=300 interface=ether2


/ip address
add address=172.31.100.1/24 interface=vlan100
add address=172.31.200.1/24 interface=vlan200
add address=172.31.30.1/24 interface=vlan300


/ip firewall nat
add chain=srcnat out-interface=ether1 action=masquerade


/ip route
add dst-address=192.168.40.0/24 gateway=10.20.0.2
add dst-address=192.168.50.0/24 gateway=10.20.0.2
add dst-address=192.168.60.0/24 gateway=10.20.0.2
