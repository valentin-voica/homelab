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

## ArubaOS - Upgrading Wireless Access Points

Download the latest version from [HPE Ntworking Support Portal](https://networkingsupport.hpe.com/) and save it to the “Downloads” folder.

Start a TFTP ([Tftpd64](https://pjo2.github.io/tftpd64/)) or an SFTP ([Rebex](https://www.rebex.net/tiny-sftp-server/)) server.

Open a console connection to the AP and run the following command (adjust the file name as required):

```
aruba-ap# upgrade-image2-no-reboot tftp://172.20.10.104/ArubaInstant_Hercules_8.9.0.3_83448
```

Reboot the AP when convenient.

## Troubleshooting Commands

`AP# show version`

`AP# show image version`

`AP# show upgrade`

`AP# show swarm image-sync`

If the output shows:

```
[...]
Image Sync Pending    :Yes
[...]
```

Reboot this AP. Update the firmware on the other APs.

## SSH access using public-key authentication

### Client (Laptop)

If not already completed, generate the public/private key pair for the client (laptop).

Copy / export the public key into a client public-key text file (i.e. `Identity.pub`, `id_rsa.pub` etc).

To view the key properties:

`ssh-keygen -lf ~/.ssh/id_rsa.pub`

Pull this file into the switch:

`switch(config)# copy tftp pub-key-file <server_IP> Identity.pub manager username admin append detail`

To display the client public keys in the switch's current client public-key file:

`show crypto client-public-key`

To delete the client public-key file:

`clear crypto client-public-key`

### Server (Switch)

Enable client public-key authentication:

`switch(config)# aaa authentication ssh enable public-key none`

To enable client public-key authentication to block SSH clients whose public keys are not in the client public-key file copied into the switch, **you must configure the Login Secondary as none**. Otherwise, the switch allows such clients to attempt access using the switch operator password.

## SSH access using RADIUS authentication

### Configuration on the Raspberry Pi freeRADIUS server

[freeRADIUS Getting Started guide](https://wiki.freeradius.org/guide/Getting%20Started)

[freeRADIUS - RADIUS Attribute List](https://freeradius.org/rfc/attributes.html)

[freeRADIUS - vendor/HP](https://wiki.freeradius.org/vendor/HP)

Edit the `users` file:

`# nano /etc/freeradius/3.0/users`

and add the following:

```
#
# Users on switch
#
user            Cleartext-Password := "password-operator"
                Service-Type = NAS-Prompt-User,
                NAS-Identifier = "switch-1",
                NAS-Port-Type = Virtual
admin           Cleartext-Password := "password-manager"
                Service-Type = Administrative-User,
                NAS-Identifier = "switch-1",
                NAS-Port-Type = Virtual

#
```

Edit the `clients.conf` file:

`# nano /etc/freeradius/3.0/clients.conf`

and add the following:

```
#  Access for switch
client new {
        ipaddr = <switch_IP>
        secret = aruba123
}
```

Start the server in debugging mode:

`# freeradius -X`

and follow the output during authentication.

When all is good, start and enable the `freeradius` service to start automatically after each boot:

`# systemctl start freeradius.service`
`# systemctl enable freeradius.service`

### Initial RADIUS management configuration on the switch

[Configuring the switch for RADIUS authentication](https://techhub.hpe.com/eginfolib/Aruba/16.09/5200-5903/index.html#s_Configuring_the_switch_for_RADIUS_authentication.html)

```
switch(config)# radius-server host radius.voica.lan key testing123
switch(config)# radius-server timeout 2
switch(config)# radius-server retries 2
```

Verify the configuration:

```
switch(config)# show radius

 Status and Counters - General RADIUS Information

 Dead RADIUS server are preceded by *

  Deadtime (minutes)             : 0           TLS Dead Time (minutes)          : 0
  Timeout (seconds)              : 2           TLS Timeout (seconds)            : 30
  Retransmit Attempts            : 2           TLS Connection Timeout (seconds) : 30
  Global Encryption Key          :
  Dynamic Authorization UDP Port : 3799
  Source IP Selection            : Outgoing Interface
  Source IPv6 Selection          : Outgoing Interface
  Tracking                       : Disabled
  Request Packet Count           : 3
  Track Dead Servers Only        : Disabled
  Tracking Period (seconds)      : 300
  ClearPass Identity             :

                  Auth  Acct  DM/ Time   |
  Server IP Addr  Port  Port  CoA Window | Encryption Key                                           OOBM
  --------------- ----- ----- --- ------ + -------------------------------------------------------- ----
  10.0.19.5       1812  1813  No  300    | aruba123                                                 No
```

### SSH Configuration for RADIUS authentication

```
switch(config)# aaa authentication num-attempts 2
switch(config)# aaa authentication ssh login radius local
switch(config)# aaa authentication ssh enable radius local
switch(config)# aaa authentication login privilege-mode
```

`switch(config)# aaa authentication disable-username` - apparently has effect only when manager and operator user names are not set
