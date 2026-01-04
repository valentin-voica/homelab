## Mealie - Recipe Management

Use the ["hkotel" image](https://hub.docker.com/r/hkotel/mealie)

[Mealie](https://mealie.io/)

### Docker Swarm

#### Prepare the environment

In the `home` directory, create subdirectories for the Docker Compose file and for configuration files:

`mkdir config/mealie`

`mkdir appdata/mealie`

#### Configuration

Replace the example domains with the real subdomains in the `mealie.env` and `mealie.yml` files.

#### Deploy the app

`$ docker stack deploy mealie --compose-file config/mealie/mealie.yml `

Confirm the app is running without errors:

`$ docker stack ps mealie`

## Docker Compose

#### Directory structure

```
.
├── docker
│   ├── mealie
│   │   ├── docker-compose.yml
│   │   ├── mealie.env
│   │   └── mealie_data
```

#### Configuration

Replace the example domains with the real subdomains in the `mealie.env` and `mealie.yml` files.
