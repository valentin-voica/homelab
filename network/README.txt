# Networking

## Management VLAN ACL example

The example shows the configuration for an ArubaOS-CX switch.

```
Switch(config)# show access-list config 

ip access-list extended "MGMT" 
   10 remark "Allow access from management station(s) only" 
   20 permit ip 192.168.98.1 0.0.0.0 192.168.98.144 0.0.0.15 
   30 permit ip 192.168.98.2 0.0.0.0 192.168.98.144 0.0.0.15 
   40 deny ip 192.168.98.0 0.0.0.31 192.168.98.144 0.0.0.15 
   50 remark "Allow devices on MGMT VLAN to access any network" 
   60 permit ip 192.168.98.144 0.0.0.15 0.0.0.0 255.255.255.255 
   70 permit ip 0.0.0.0 255.255.255.255 192.168.98.144 0.0.0.15 
   80 remark "Implicit deny any any" 
   90 deny ip 0.0.0.0 255.255.255.255 0.0.0.0 255.255.255.255 
   exit
```

