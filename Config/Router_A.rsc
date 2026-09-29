
# 1. Asignar direcciones IP a las interfaces
/ip address
add address=10.11.0.1/30 interface=ether1 comment="WAN ISP"
add address=10.20.0.1/30 interface=ether3 comment="Enlace a Router B"

# 2. Configurar Gateway por defecto (Ruta estática hacia el ISP)
/ip route
add dst-address=0.0.0.0/0 gateway=10.11.0.2 comment="Salida a Internet"

# 3. Configurar VLANs en la interfaz LAN (ether2)
# Nota: En MikroTik, se crean interfaces VLAN virtuales sobre la interfaz física.
/interface vlan
add name=vlan100 vlan-id=100 interface=ether2
add name=vlan200 vlan-id=200 interface=ether2
add name=vlan300 vlan-id=300 interface=ether2

# 4. Asignar IPs a las VLANs (Las puertas de enlace para los switches)
/ip address
add address=172.31.100.1/24 interface=vlan100
add address=172.31.200.1/24 interface=vlan200
add address=172.31.30.1/24 interface=vlan300

# 5. Configurar NAT (Masquerade) para que las VLANs salgan a Internet
/ip firewall nat
add chain=srcnat out-interface=ether1 action=masquerade

# 6. Ruta estática hacia las redes del Router B (VLANs 400, 500, 600)
/ip route
add dst-address=192.168.40.0/24 gateway=10.20.0.2
add dst-address=192.168.50.0/24 gateway=10.20.0.2
add dst-address=192.168.60.0/24 gateway=10.20.0.2