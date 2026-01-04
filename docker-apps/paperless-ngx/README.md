## Paperless-ngx

Document Management System (DMS)

Follow the official instructions [here](https://docs.paperless-ngx.com/setup/#docker)

### Backup

Change to the `paperless-ngx` application directory.

The script I use, based on the [official documentation](https://docs.paperless-ngx.com/administration/#backup):

`~/docker/paperless$ docker compose exec -T webserver document_exporter ../export --use-filename-format --use-folder-prefix --delete`

Copy the `../export` folder to the destination (example):

`rsync -azP /home/<username>/paperless/export/ <username>@<server>:/<path_to_backup_location>/`

### Restore

The script I use, based on the [official documentation](https://docs.paperless-ngx.com/administration/#migrating-restoring):

`docker compose exec webserver document_importer ../export`

That's all about it...

### Transfer files to the `consume` directory

`rync -azP <path_to_source_directory> <username>@<self_hosted_server>:/home/<username>/paperless/consume/`
