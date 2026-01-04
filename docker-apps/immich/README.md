# Immich

A personal, on-premises solution for photo and video management

## Initial Configuration

Follow the instruction on the [official Immich documentation](https://immich.app/docs/overview/quick-start/).

Directory structure:

```
.
├── docker
│   ├── immich-app
│   │   ├── .env
│   │   ├── docker-compose.yml
│   │   ├── library
|   |   ├── pictures
│   │   └── postgres
```

Change directory to `~/docker/immich` and create the `.env` and `docker-compose.yml` files.

To the original `docker-compose.yml` file I have only added the `caddy` network and labels. Don't forget to replace the `example.com` domain with your FQDN and add the entry to the DNS records.

## Immich CLI

### Upload pictures in bulk

[Immich CLI](https://immich.app/docs/features/command-line-interface/)

Syncroniza the local `Pictures` directory with the server where Immich is running (replace `user` and `server.example.internal`):

`rsync -az Pictures/Album/ user@myserver.example.internal:/home/user/docker/immich-app/pictures/`

Run the following commands from within the `immich-app` directory.

Test by showing the immich-app version:

`docker run -it -v "$(pwd)":/import:ro -e IMMICH_INSTANCE_URL=https://photos.example.com/api -e IMMICH_API_KEY=immich-api-key ghcr.io/immich-app/immich-cli:latest --version`

Example output:

`2.2.68`

Upload the pictures:

`docker run -it -v "$(pwd)":/import:ro -e IMMICH_INSTANCE_URL=https://photos.example.com/api -e IMMICH_API_KEY=immich-api-key ghcr.io/immich-app/immich-cli:latest upload --recursive pictures/`

### Backup and Restore

#### Backup

Change directory to `~/docker/immich` and run the `./immich_backup.sh` script shown below. The backup's destination is on my other server in the home lab.

The `./library' directory includes the 2:00 AM daily backups. You can later restore using one of those database backups.

The timestamp.sh script and the log are described in another note.

Create the backup script - it can be added to Cron later. Remember to replace the `user` and `myserver.example.internal`. Create the `immich_backup` directory on the USB HDD.

`nano immich_backup.sh`

```
#!/bin/bash

echo "Stop the Immich app"

docker compose down

echo "Backup of './library' directory started"

# Remote Location
rsync -azP --delete /home/user/docker/immich-app/library user@myserver.example.internal:/home/user/immich_backup/ 2>&1 | /usr/local/bin/timestamp.sh >> /var/log/immich_backup.log

# Local USB HDD
rsync -azP --delete /home/user/docker/immich-app/library /mnt/usb/immich_backup/ 2>&1 | /usr/local/bin/timestamp.sh >> /var/log/immich_backup.log

echo "Backup completed. Wait 10 seconds before restarting the app..."

sleep 10

echo "Starting the app"

docker compose up -d

echo "===================================================="
```
