# Basic configuration I put on Ubuntu servers
		
## Supermicro X11SSL-F

To boot from NVME SSD in PCIe (with adapter) change "NVMe Firmware source" to "AMI Native Support"

## Change the hostname

### The "hosts" file

```
# nano /etc/hosts
```

Add the following line:

```
127.0.1.1       moby-dick
```

The resulting file:

```
# /etc/hosts
127.0.0.1       localhost
127.0.1.1       moby-dick 
[...]
```

### The "hostname" file

```
# nano /etc/hostname
```

Replace `localhost` with the new name (i.e. `moby-dick`). The file must have one line only.

## Update the system

```
# apt update && apt full-upgrade -y
```

Reboot.

## Create a new, non-root user

[Source](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-22-04)

Add a new user:

```
# adduser valentin
```

Grant administrative privileges:

```
# usermod -aG sudo valentin
```

Verify:

`# su valentin`

Output:

```
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

valentin@moby-dick:/root$
```

## Prompt for the `root` Password Once Per Terminal Session

Always use `visudo`!!!

To enter the `sudo` password only once per session, add the following line in the `sudoers` file:

`Defaults timestamp_timeout = -1`

## Install the Ubuntu Pro client

`# apt install ubuntu-advantage-tools`

To check which version of the Ubuntu Pro Client you are using, run:

`# pro version`

Attach the system to the Ubuntu Pro license:

`sudo pro attach ***************************`

## Add the machine to Landscape

`# apt install landscape-client`

`# landscape-config --computer-title "moby-dick" --account-name <account_id_here>`

Follow the instructions on Landscape portal to add the machine.

## Set up the firewall (UFW)

```
# ufw app list
```

Output:

```
Available applications:
  OpenSSH
```

Make sure that the firewall allows SSH connections:

```
# ufw allow OpenSSH
```

Enable the firewall:

```
# ufw enable
```

Answer "yes" when prompted for confirmation:

```
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
```

Check OpenSSH is allowed:

```
# ufw status
```

Output:

```
Status: active

To                         Action      From
--                         ------      ----
OpenSSH                    ALLOW       Anywhere                  
OpenSSH (v6)               ALLOW       Anywhere (v6)             
```

## Configure remote access

Use public key for SSH authentication

Connecting to a remote system without entering the password every time. [Source](https://https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04)

### Create the RSA key pair

On the client machine (i.e. laptop), run the following command from the user prompt (`$`) not the root (`#`). This will generate a "Ed25519" type of key.

```
$ ssh-keygen -t ed25519
```

Select to store the keys to the default location (`$HOME/.ssh/`) and leave empty for passphrase.

### Copy the public key to the remote server

#### Using the `ssh-copy-id` script

```
$ ssh-copy-id user@host
```

#### Manually

On the remote server:

```
$ mkdir ~/.ssh/
$ chmod 700 ~/.ssh  # this is important.
$ touch ~/.ssh/authorized_keys
$ chmod 600 ~/.ssh/authorized_keys  #this is important.
```

On the local host:

```
$ scp $HOME/.ssh/id_rsa.pub user@host:$HOME/.ssh/
```

On the remote server:

```
$ cat ~/.ssh/id_rsa.pub
```

and copy all the content into the clipboard.

Open the `authorized_keys` file:

```
$ nano ~/.ssh/authorized_keys
```

and paste the clipboard content.

Save, exit, and test:

```
$ ssh user@host
```

### Delete the stored keys

Edit the `authorized_keys` file:

```
$ nano $HOME/.ssh/authorized_keys
```

and delete the stored keys.

### View the known hosts on the client

```
$ cat $HOME/.ssh/known_hosts
```

## Disable root login and password based login

This step is optional, but it is a best practice.

### Option 1 - Add a new configuration file in the `/etc/ssh/sshd_config.d` directory (recommended)

The new configuration file is named `50-cloud-init.conf` (consistent with Debian 12).

```
$ sudo nano /etc/ssh/sshd_config.d/50-cloud-init.conf
```

Copy and paste the following:

```
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
UsePAM no
```

### Option 2 - Edit the `sshd_config` file

On the remote server, edit the `sshd_config` file:

```
$ sudo nano /etc/ssh/sshd_config
```

Set the following parameters as shown:

* Set `PermitRootLogin no`
* Uncomment `PubkeyAuthentication yes`
* Set `PasswordAuthentication no`
* Check `ChallengeResponseAuthentication no`or `KbdInteractiveAuthentication no`
* Set `UsePAM no`

Save and close the file

### Testing

Restart the ssh service:

```
$ sudo systemctl restart ssh.service
```

On the client machine, test by trying to login as root:

```
$ ssh root@host
```

and by trying to login as user, with password only:

```
$ ssh user@host -o PubkeyAuthentication=no
```

Both should return:

```
Permission denied (publickey).
```

## Enable "Tab" key auto-completion

Install the "bash-completion" package then reboot the system.

```
$ sudo apt install bash-completion
```
