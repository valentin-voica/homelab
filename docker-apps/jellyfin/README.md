# Jellyfin

[Project page](https://jellyfin.org/)

Self-hosted media server behind traefik v2 reverse proxy.

## Prepare the environment

Create directories for the Docker Compose configuration file and for the data storage (cache, metadata, plugins, transcodes, logs):

`mkdir config/jellyfin`

`mkdir appdata/jellyfin`

Create a directory for the media content:

`sudo mkdir -p /mnt/datastore/media/videos/{concerts,films,musicals,tvprogrammes,tvseries}`

## Docker Compose file

`config/jellyfin/jellyfin.yml`

Replace "example.com" with the real subdomain.

## Deploy the app

`$ docker stack deploy jellyfin --compose-file config/jellyfin/jellyfin.yml `

Confirm the app is running without errors:

`$ docker stack ps jellyfin`

```
ID             NAME                  IMAGE                      NODE      DESIRED STATE   CURRENT STATE         ERROR     PORTS
rb1h46zrjtc1   jellyfin_jellyfin.1   jellyfin/jellyfin:latest   traian    Running         Running 2 weeks ago
```
