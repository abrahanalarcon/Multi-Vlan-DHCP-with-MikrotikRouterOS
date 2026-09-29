# Laboratorio VLAN + Router-on-a-Stick + Switching

## Objetivo
Topología de seis switches dividida en dos dominios LAN. El enrutamiento inter-VLAN lo realizan subinterfaces de Router A y Router B; los switches trabajan como capa 2.

## Topología lógica

```text
Router A -- trunk -- SW1 -- trunk -- SW2 (VLAN 100)
                    |  \-- trunk -- SW3 (VLAN 200)
                    +-- puertos locales VLAN 300

Router B -- trunk -- SW4 -- trunk -- SW5 (VLAN 400)
                    |  \-- trunk -- SW6 (VLAN 500)
                    +-- puertos locales VLAN 600
```

## Plan de VLAN y direccionamiento

| VLAN | Red | Gateway de ejemplo | Switch / ubicación |
|---:|---|---|---|
| 100 | 172.31.100.0/24 | 172.31.100.1 | SW2 |
| 200 | 172.31.200.0/24 | 172.31.200.1 | SW3 |
| 300 | 172.31.30.0/24 | 172.31.30.1 | Puertos locales SW1 |
| 400 | 192.168.40.0/24 | 192.168.40.1 | SW5 |
| 500 | 192.168.50.0/24 | 192.168.50.1 | SW6 |
| 600 | 192.168.60.0/24 | 192.168.60.1 | Puertos locales SW4 |

Los gateways son valores de referencia: deben coincidir con las subinterfaces configuradas en los routers.

## Distribución de puertos

### Switches de distribución (SW1 y SW4)
- Gi0/22: trunk al router.
- Gi0/23 y Gi0/24: trunks a switches de acceso.
- Gi0/1-12: puertos locales de acceso (VLAN 300 en SW1; VLAN 600 en SW4).
- Gi0/13-21: reservados, en VLAN 999 y apagados.

### Switches de acceso (SW2, SW3, SW5 y SW6)
- Gi0/24: trunk al switch de distribución.
- Gi0/1-16: puestos de usuario.
- Gi0/17-20: impresoras, equipos auxiliares o dispositivos IoT de la misma VLAN del switch.
- Gi0/21-23: reserva, VLAN 999 y apagados.

| Switch | VLAN de acceso | Trunk uplink |
|---|---:|---|
| SW1 | 300 en Gi0/1-12 | Gi0/22 Router A, Gi0/23 SW2, Gi0/24 SW3 |
| SW2 | 100 en Gi0/1-20 | Gi0/24 SW1 |
| SW3 | 200 en Gi0/1-20 | Gi0/24 SW1 |
| SW4 | 600 en Gi0/1-12 | Gi0/22 Router B, Gi0/23 SW6, Gi0/24 SW5 |
| SW5 | 400 en Gi0/1-20 | Gi0/24 SW4 |
| SW6 | 500 en Gi0/1-20 | Gi0/24 SW4 |

## ¿Por qué esta distribución?
1. Se reservan los puertos superiores para uplinks, para identificar fácilmente los enlaces troncales.
2. Los puertos de usuarios y equipos se agrupan por función.
3. Se dejan puertos libres para crecimiento.
4. Los puertos no usados se apagan y se colocan en VLAN 999 (parking VLAN).
5. PortFast y BPDU Guard se habilitan en los puertos finales, no en los trunks.
6. SW1 es root STP para VLAN 100/200/300; SW4 es root para VLAN 400/500/600.

> La imagen no especifica qué dispositivo final se conecta a cada puerto. La distribución de puertos finales es una propuesta ordenada de laboratorio y se debe ajustar al cableado real. Si un puerto de acceso conecta a un switch adicional, no uses PortFast en ese puerto: conviértelo en trunk y revisa el diseño STP.

## Router-on-a-Stick: ejemplo Router A

Ajusta la interfaz física a la que realmente conecta SW1.

```cisco
interface GigabitEthernet0/2
 no ip address
 no shutdown
interface GigabitEthernet0/2.100
 encapsulation dot1Q 100
 ip address 172.31.100.1 255.255.255.0
interface GigabitEthernet0/2.200
 encapsulation dot1Q 200
 ip address 172.31.200.1 255.255.255.0
interface GigabitEthernet0/2.300
 encapsulation dot1Q 300
 ip address 172.31.30.1 255.255.255.0
```

## Router-on-a-Stick: ejemplo Router B

```cisco
interface GigabitEthernet0/2
 no ip address
 no shutdown
interface GigabitEthernet0/2.400
 encapsulation dot1Q 400
 ip address 192.168.40.1 255.255.255.0
interface GigabitEthernet0/2.500
 encapsulation dot1Q 500
 ip address 192.168.50.1 255.255.255.0
interface GigabitEthernet0/2.600
 encapsulation dot1Q 600
 ip address 192.168.60.1 255.255.255.0
```

## Verificación
Ejecuta en cada switch:

```cisco
show vlan brief
show interfaces trunk
show interfaces status
show spanning-tree
show running-config
```

Pruebas sugeridas:
- Un host de cada VLAN debe poder hacer ping a su gateway.
- Dos hosts de la misma VLAN deben comunicarse si están en la misma subred y no hay otra política que lo impida.
- Hosts de VLAN distintas requieren routing en el router.
- Para comunicación entre Router A y Router B o hacia Internet también hacen falta rutas y políticas adecuadas; la configuración de switches por sí sola no las crea.

## Archivos
- `SW1.cfg` a `SW6.cfg`: configuración individual para cada switch.
- `VLAN_PLAN.md`: resumen de VLANs, subredes y gateways.

## Precauciones
- Antes de pegar la configuración, confirma que el equipo usa nombres de interfaz `GigabitEthernet0/x`. En otros modelos puede ser `FastEthernet0/x` o `GigabitEthernet1/0/x`.
- Confirma qué puerto físico conecta a cada equipo.
- Los trunks están configurados para permitir solo las VLAN necesarias.
- Los puertos apagados deben activarse y asignarse a la VLAN correspondiente cuando se utilicen.
