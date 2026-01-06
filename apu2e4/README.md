# PC Engines "apu2e4" board

## BIOS Upgrade

Source: [APU2 APU3 APU4 BIOS upgrade instructions](https://teklager.se/en/knowledge-base/apu-bios-upgrade/)

### Using Serial Communication

Open a console session as root.

Connect both the console cable and the network cable to `enp1s0` (the LAN interface next to the serial port), then power up the device.

When prompted, press F10 for the boot menu and select the USB drive with the Debian Live image. The "Live system (amd64)" option should already be selected; press TAB and add the below to the command line (note the space before `console`):

` console=ttyS0,115200n8`

The login prompt should show up after a couple of minutes. Logon with username `user` and password `live` then `sudo su`.

Install the `flashrom` app:
```
# apt update
# apt install flashrom
```
Download the correct BIOS for the PC:

`# wget https://3mdeb.com/open-source-firmware/pcengines/apu2/apu2_v4.17.0.3.rom`

The following command will install the new ROM:

`flashrom --write apu2_v4.17.0.3.rom --programmer internal:boardmismatch=force --chip W25Q64BV/W25Q64CV/W25Q64FV`

Output:

```
flashrom v1.3.0 on FreeBSD 14.1-RELEASE-p4 (amd64)
flashrom is free software, get the source code at https://flashrom.org

Using clock_gettime for delay loops (clk_id: 4, resolution: 2ns).
coreboot table found at 0xdffae000.
Found chipset "AMD FCH".
Enabling flash write... OK.
Found Winbond flash chip "W25Q64BV/W25Q64CV/W25Q64FV" (8192 kB, SPI) mapped at physical address 0x00000000ff800000.
This coreboot image (PC Engines:apu2) does not appear to
be correct for the detected mainboard (PC Engines:PCEngines apu2).
Proceeding anyway because user forced us to.
Reading old flash chip contents... done.
Erasing and writing flash chip... Erase/write done.
Verifying flash... VERIFIED.
```
Check the BIOS version with `dmidecode`.
