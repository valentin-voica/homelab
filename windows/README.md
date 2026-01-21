## Wallpapers Location in Windows 10

`C:\Windows\Web\Screen`

## Useful Apps

* EXIF Date Changer
* ExifTool and ExifToolGUI
* PhotoMove 2.5
(for the Pro version: Email: valentin@voica.uk, Password: 18230662)
* Remove Empty Directories (RED)
* SD Memory Card Formatter
* H2testw (SD card performance test for reading and writing data)

## Enable Oracle VM VirtualBox and Disable Hyper-V

VirtualBox won't work if Hyper-V is enabled. To disable Hyper-V follow the steps below.

Open the command prompt **as administrator** and run the command with no argument:

`bcedit`

After you run the above command, you will see that the property `hypervisorlaunchtype` is set Auto by default:

`[...]`
`hypervisorlaunchtype    Auto`

<img width="1357" height="763" alt="oracle_vm-hyper_v" src="https://github.com/user-attachments/assets/6c7e78b3-0c22-444f-9781-f2ef98c9cac1" />

### Disable Hyper-V and enable VirtualBox

Run:

`bcdedit /set hypervisorlaunchtype off`

Restart the PC.

### Re-enable Hyper-V

Run:

`bcdedit /set hypervisorlaunchtype auto`

Restart the PC.

## Convert the partition table format from GPT to MBR

Open a Command Prompt window and enter the following commands:

`diskpart`

`list disk`

`select disk <no>`

`clean`

`convert mbr`

`create partition primary`

`list volume`

`select volume <no>`

`format fs=ntfs`

`exit`

## Reinstall all the Windows 10 provisioned apps

Create a Powershell script (PS1 extension) with the following content:

```
# Get all the provisioned packages
$Packages = (get-item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Applications') | Get-ChildItem

# Filter the list if provided a filter
$PackageFilter = $args[0]
if ([string]::IsNullOrEmpty($PackageFilter))
{
	echo "No filter specified, attempting to re-register all provisioned apps."
}
else
{
	$Packages = $Packages | where {$_.Name -like $PackageFilter}

	if ($Packages -eq $null)
	{
		echo "No provisioned apps match the specified filter."
		exit
	}
	else
	{
		echo "Registering the provisioned apps that match $PackageFilter"
	}
}

ForEach($Package in $Packages)
{
	# get package name & path
	$PackageName = $Package | Get-ItemProperty | Select-Object -ExpandProperty PSChildName
	$PackagePath = [System.Environment]::ExpandEnvironmentVariables(($Package | Get-ItemProperty | Select-Object -ExpandProperty Path))

	# register the package	
	echo "Attempting to register package: $PackageName"

	Add-AppxPackage -register $PackagePath -DisableDevelopmentMode
}
```

## Sync Files with Robocopy

[robocopy](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy)

### Script to sync on a network drive

```
@Echo off
Echo Close all running programs!!
pause

: Maps the backup folder on the NAS as local Z drive
: net use Z: \\10.10.10.2\test /USER:EMEA-L-09310\test passw0rd /PERSISTENT:NO

: Sets the proper date and time stamp with 24Hr Time
SET HOUR=%time:~0,2%
SET dtStamp9=%date:~-4,4%%date:~-7,2%%date:~-10,2%_0%time:~1,1%%time:~3,2%%time:~6,2%
SET dtStamp24=%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%
if "%HOUR:~0,1%" == " " (SET dtStamp=%dtStamp9%) else (SET dtStamp=%dtStamp24%)

: Creates the user folder on the mapped drive with date stamp in the name
mkdir Z:\work\%USERNAME%\%dtStamp%

: This is the backup script
robocopy "C:\Users\%USERNAME%" "Z:\work\%USERNAME%\%dtStamp%"  /MIR /XA:SH /XD AppData /XJD /R:3 /W:10 /MT:64 /V /NP /LOG:C:\BackupTool\Backup.log

: Disconnects the previouslu mapped drive
: net use Z: /delete

Echo Completed. Check the 'C:\BackupTool\Backup.log' file for any errors!
pause
```

### Script to sync on a USB drive:

```
@Echo off
Echo Close all running programs!!
pause

: Sets the proper date and time stamp with 24Hr Time
SET HOUR=%time:~0,2%
SET dtStamp9=%date:~-4,4%%date:~-7,2%%date:~-10,2%_0%time:~1,1%%time:~3,2%%time:~6,2%
SET dtStamp24=%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%
if "%HOUR:~0,1%" == " " (SET dtStamp=%dtStamp9%) else (SET dtStamp=%dtStamp24%)

: Creates the user folder on the USB drive with date stamp in the name
mkdir D:\work\%USERNAME%\%dtStamp%

robocopy "C:\Users\%USERNAME%" "D:\work\%USERNAME%\%dtStamp%" /MIR /XA:SH /XD AppData /XJD /R:3 /W:10 /MT:64 /V /NP /LOG:Backup.log

Echo Completed. Check the 'C:\BackupTool\Backup.log' file for any errors!
pause
```

## Unattended upgrade to Windows 10

The original article on LifeHacker: [Quickly Upgrade Windows 7 to Windows 10 for Free With This PowerShell Script](https://lifehacker.com/quickly-upgrade-windows-7-to-windows-10-for-free-with-t-1840843214)

Open PowerShell as administrator and run the command:

`Set-ExecutionPolicy Unrestricted`

Close PowerShell.

Open a new text file and paste the following:

```
$dir = "c:\temp"
mkdir $dir
$webClient = New-Object System.Net.WebClient
$url = "https://go.microsoft.com/fwlink/?LinkID=799445"
$file = "$($dir)\Win10Upgrade.exe"
$webClient.DownloadFile($url,$file)
Start-Process -FilePath $file -ArgumentList "/quietinstall /skipeula /auto upgrade /copylogs $dir" -verb runas
```
Save the file with the extension PS1.

Right-click the PS1 file and select 'Run with PowerShell".

Check that the installation in Task Manager ("Windows10UpgraderApp.exe") application is running.

Reset PowerShell’s execution policy:

`Set-ExecutionPolicy Restricted`


## Get Serial Number, Make and Model etc

`wmic bios get serialnumber`

`wmic csproduct get vendor, version`

`wmic computersystem get model,name,manufacturer,systemtype`

After downloading "iperf", add its folder path (ex. `C:\Program Files\iperf-3.1.3-win64\`) to the "System / User Environment Variables" then logoff and logon.

On the server, run Command Prompt **as administrator**.

## Speed Test with iPerf3

### LAN Speed Test

On one PC run iperf as a server:

`C:\iperf3.exe -s`

On the other PC run iperf as a client (open Command Prompt as **administrator**):

`C:\iperf3.exe -c <server_ip_address> -p <port_number> -P 10 -t 20 -R`

Example:

`C:\WINDOWS\system32>iperf3.exe -c 185.132.40.12 -p 5201 -P 10 -t 20 -R`

**Example for a public iperf server (WAN Speed Test):**

`iperf3.exe --client ping.online.net --port 5206 --format m --parallel 10 --time 20 --reverse`

### Simulate a Voice Call

On one PC run iperf as a server:

`C:\iperf3.exe -s -u`
`pause` <-- not sure why

On the other PC run iperf as a client:

`C:\iperf3.exe -c <server_ip_address> -u -d -b 94500 -l 240 -t 10`
`pause` <-- not sure why

## Backup Scripts

### With no time stamp

```
@Echo off
Echo Close all running programs!!
pause

robocopy "Y:" "D:" /MIR /XA:SH /REG /R:1 /W:0 /MT:64 /NP /V /LOG:Backup.log

Echo Completed. Check the 'C:\BackupTool\Backup.log' file for any errors!
pause
```

### With time stamp
```
@Echo off
Echo Close all running programs!!
pause

: Sets the proper date and time stamp with 24Hr Time
SET HOUR=%time:~0,2%
SET dtStamp9=%date:~-4,4%%date:~-7,2%%date:~-10,2%_0%time:~1,1%%time:~3,2%%time:~6,2%
SET dtStamp24=%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%
if "%HOUR:~0,1%" == " " (SET dtStamp=%dtStamp9%) else (SET dtStamp=%dtStamp24%)

: Creates the backup directory on the USB drive with date stamped sub-directory
mkdir D:\backup\%dtStamp%

robocopy "Z:" "D:\backup\%dtStamp%" /MIR /XA:SH /REG /R:1 /W:0 /MT:64 /NP /V /LOG:Backup.log

Echo Completed. Check the 'C:\BackupTool\Backup.log' file for any errors!
pause
```
