# 2025-11-04 13:06:16 by RouterOS 7.20.4
# software id = 1PUJ-LG6G
#
# model = RB941-2nD
# serial number = HGG09MSPPX8

/interface wireless
set [ find default-name=wlan1 ] ssid=MikroTik

/interface vlan
add interface=ether2 name=vlan400 vlan-id=400
add interface=ether2 name=vlan500 vlan-id=500
add interface=ether2 name=vlan600 vlan-id=600

/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik

/ip pool
add name=pool400 ranges=192.168.40.10-192.168.40.100
add name=pool500 ranges=192.168.50.10-192.168.50.100
add name=pool600 ranges=192.168.60.10-192.168.60.100

/ip dhcp-server
add address-pool=pool400 interface=vlan400 name=dhcp400
add address-pool=pool500 interface=vlan500 name=dhcp500
add address-pool=pool600 interface=vlan600 name=dhcp600

/ip neighbor discovery-settings
set discover-interface-list=!dynamic

/ip address
add address=10.20.0.1/30 comment=Hacia-RouterA interface=ether4 network=\ 10.20.0.0
add address=192.168.40.1/24 interface=vlan400 network=192.168.40.0
add address=192.168.50.1/24 interface=vlan500 network=192.168.50.0
add address=192.168.60.1/24 interface=vlan600 network=192.168.60.0
add address=10.1.1.6/30 comment="hacia al isp (profesor)" interface=ether3 \ network=10.1.1.4

/ip dhcp-server network
add address=192.168.40.0/24 dns-server=10.50.0.1 gateway=192.168.40.1
add address=192.168.50.0/24 dns-server=10.50.0.1 gateway=192.168.50.1
add address=192.168.60.0/24 dns-server=10.50.0.1 gateway=192.168.60.1

/ip dns
set servers=10.1.1.5

/ip firewall nat
add action=masquerade chain=srcnat log=yes out-interface=ether3

/ip route
add disabled=no distance=1 dst-address=0.0.0.0/0 gateway=10.1.1.5 \ routing-table=main scope=30 suppress-hw-offload=no target-scope=10
add dst-address=172.31.100.0/24 gateway=10.20.0.2
add dst-address=172.31.200.0/24 gateway=10.20.0.2
add dst-address=172.31.30.0/24 gateway=10.20.0.2
