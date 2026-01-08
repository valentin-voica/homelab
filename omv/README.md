# OpenMediaVault (OMV)

## Notes:

* Before configuring or adding users (changing the `postfix` configuration), configure the "Notifications" settings in the "System" menu.

* If using the "openmediavault-usbbackup" plug-in, make sure the destination USB drive is NOT mounted.

Sync file, without changing permissions at the destination:

`rsync -rP --delete Archive/ valentin@omv:/srv/dev-disk-by-uuid-7efd01bf-7b11-4e2a-86f0-de951cd8b6f8/share/Archive/`

