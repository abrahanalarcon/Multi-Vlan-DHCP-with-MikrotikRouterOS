# 1. Asignar direcciones IP
/ip address
add address=10.11.0.5/30 interface=ether1 comment="WAN ISP"
add address=10.20.0.2/30 interface=ether3 comment="Enlace a Router A"

# 2. Gateway por defecto
/ip route
add dst-address=0.0.0.0/0 gateway=10.11.0.6 comment="Salida a Internet"

# 3. Configurar VLANs en ether2
/interface vlan
add name=vlan400 vlan-id=400 interface=ether2
add name=vlan500 vlan-id=500 interface=ether2
add name=vlan600 vlan-id=600 interface=ether2

# 4. Asignar IPs a las VLANs
/ip address
add address=192.168.40.1/24 interface=vlan400
add address=192.168.50.1/24 interface=vlan500
add address=192.168.60.1/24 interface=vlan600

# 5. NAT para salir a Internet
/ip firewall nat
add chain=srcnat out-interface=ether1 action=masquerade

# 6. Ruta estática hacia las redes del Router A (VLANs 100, 200, 300)
/ip route
add dst-address=172.31.100.0/24 gateway=10.20.0.1
add dst-address=172.31.200.0/24 gateway=10.20.0.1
add dst-address=172.31.30.0/24 gateway=10.20.0.1
