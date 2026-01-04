## Navidrome

Follow the instruction on the official Navidrome website [here](https://www.navidrome.org/docs/installation/docker/).

### Directory structure

Example:

```
.
├── docker
│   ├── navidrome
│   │   ├── data
│   │   └── docker-compose.yml
|
├── media
│   └── music
```

### Configuration

In the `docker-compose.yml` file replace "music.example.com" with the real subdomain.

### Automated Backup

Instructions [here](https://www.navidrome.org/docs/usage/backup/).

Only the database is backed up; manually copy the music folder(s).

`$ docker compose run navidrome backup create`

Carefully read the instructions for restoring the database.

Example restore command:

`$ docker compose run --remove-orphans navidrome backup restore --backup-file /backup/navidrome_backup_2025.12.09_08.18.37.db`
