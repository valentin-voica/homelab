# Raspberry Pi OS (Trixie)

## Static IP address

[Set a static IP Address on Raspberry Pi OS Trixie](https://www.abelectronics.co.uk/kb/article/31/set-a-static-ip-address-on-raspberry-pi-os-trixie)

Find the name of the network interface:

`sudo nmcli -p connection show`

Example output:

```
======================================
  NetworkManager connection profiles
======================================
NAME                UUID                                  TYPE      DEVICE 
------------------------------------------------------------------------------------------------------------------
Wired connection 1  76ca3a82-8d0c-34d1-8bf9-78b3d738f628  ethernet  eth0   
lo                  4a42e4cc-bd60-4a79-80f6-17d5f6a40912  loopback  lo     
```

Assuming the network interface name is "Wired connection 1" as in the example above, update the network connection:

* IP address: `sudo nmcli connection modify "Wired connection 1" ipv4.addresses 192.168.88.11/24 ipv4.method manual`

* Gateway: `sudo nmcli connection modify "Wired connection 1" ipv4.gateway 192.168.88.1`

* DNS IP address: `sudo nmcli connection modify "Wired connection 1" ipv4.dns 192.168.88.1`

* DNS search order: `sudo nmcli connection modify "Wired connection 1" ipv4.dns-search "example.internal"`

Restart the network connection

`sudo nmcli connection down "Wired connection 1" && sudo nmcli connection up "Wired connection 1"`

Reconnect using the newly configured static IP address.
