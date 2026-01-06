# Proxmox VE Knowledge Base

## Network Configuration

[Linux Bond](https://pve.proxmox.com/wiki/Network_Configuration#sysadmin_network_bond)

Using the `bond0` interface as the bridge port.

`root@pve:~# cat /etc/network/interfaces`

```
auto lo
iface lo inet loopback

iface nic0 inet manual

iface nic1 inet manual

iface nic2 inet manual

auto bond0
iface bond0 inet manual
	bond-slaves nic0 nic1
	bond-miimon 100
	bond-mode 802.3ad
	bond-xmit-hash-policy layer2+3

auto vmbr0
iface vmbr0 inet static
	address 172.16.30.2/24
	gateway 172.16.30.1
	bridge-ports bond0
	bridge-stp off
	bridge-fd 0


source /etc/network/interfaces.d/*
```

## RouterOS Monitoring

```
[valentin@fav-router] /interface/bonding> monitor lag 
                    mode: 802.3ad          
            active-ports: ether5           
                          ether6           
          inactive-ports:                  
          lacp-system-id: 04:F4:1C:9D:5D:3C
    lacp-system-priority: 65535            
  lacp-partner-system-id: E8:FF:1E:D9:62:A3
-- [Q quit|D dump|C-z pause]
```

```
[valentin@fav-router] /interface/bonding> monitor-slaves bond=lag 
Flags: A - active; P - partner 
 AP port=ether5 key=9 flags="A-GSCD--" partner-sys-id=E8:FF:1E:D9:62:A3 partner-sys-priority=65535 partner-key=9 partner-flags="A-GSCD--" 

 AP port=ether6 key=9 flags="A-GSCD--" partner-sys-id=E8:FF:1E:D9:62:A3 partner-sys-priority=65535 partner-key=9 partner-flags="A-GSCD--" 
-- [Q quit|D dump|C-z pause]
```

## Errors on uploading an ISO image

If, during uploading the file, you get the error:

"proxmox upload Error '0' occurred while receiving the document."

edit the `AnyEvent.pm` file:

`nano /usr/share/perl5/PVE/APIServer/AnyEvent.pm`

and add the line: `$reqstate->{hdl}->timeout(60);` here:

```
           $reqstate->{hdl}->timeout(60);
            $reqstate->{hdl}->on_read(sub {
                $self->file_upload_multipart($reqstate, $auth, $method, $path, >
            });
```

After saving and exiting the editor, restart the "pveproxy" service:

`systemctl restart pveproxy.service`

## Removing the Enterprise repository and adding the free one

Edit the `pve-enterprise.list` file:

`nano /etc/apt/sources.list.d/pve-enterprise.list`

Comment out the existing line and add the new one:

```
#deb https://enterprise.proxmox.com/debian/pve bookworm pve-enterprise

deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription

```

Edit the `ceph.list` file:

`nano /etc/apt/sources.list.d/ceph.list`

Comment out the existing line and add the new one:

```
#deb https://enterprise.proxmox.com/debian/ceph-quincy bookworm enterprise

deb http://download.proxmox.com/debian/ceph-quincy bookworm no-subscription
```

Update and upgrade:

`apt update && apt upgrade -y`

`apt dist-upgarde`
