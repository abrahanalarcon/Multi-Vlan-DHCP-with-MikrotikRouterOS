# Multi-Vlan-DHCP-with-Microtik

Este repositorio contiene la configuración completa y documentada para un laboratorio de red que simula una topología empresarial con dos sedes (Router A y Router B), conectadas a través de un ISP simulado. El laboratorio cubre enrutamiento estático, VLANs, DHCP, NAT y configuración de switches (Trunk/Access).
<img src="instructions" alt="Diagrama de Topología" width="600">

## 📋 Topología de Red

La red está dividida en dos sedes principales:

*   **Sede A (Router A):** Maneja las VLANs 100, 200 y 300.
*   **Sede B (Router B):** Maneja las VLANs 400, 500 y 600.
*   **ISP (Simulado):** Actúa como tránsito a Internet y alberga un servidor DNS/Web (`10.50.0.3`).
*   **Enlace Inter-Sede:** Conexión directa entre Router A y Router B para tráfico interno.

### Diagrama Lógico

```text
       [ISP] (10.50.0.3)
      /     \
 10.11.0.0/30  10.1.1.4/30
    /         \
[Router A] --- [Router B]
    |  10.20.0.0/30  |
   Sw1             Sw4
  /   \           /   \
Sw2   Sw3       Sw5   Sw6
(VLAN100)(VLAN200)(VLAN400)(VLAN500)
