# L4N

[![CI check](https://github.com/Adrian-Hirt/l4n/actions/workflows/ci.yml/badge.svg)](https://github.com/Adrian-Hirt/l4n/actions/workflows/ci.yml)
[![Edge docker image](https://github.com/Adrian-Hirt/l4n/actions/workflows/build_edge_docker.yml/badge.svg)](https://github.com/Adrian-Hirt/l4n/actions/workflows/build_edge_docker.yml)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

**The Readme is work in progress, please contact the maintainers if you should have any questions**

L4N is a CMS for managing LAN parties, featuring a ticketing system, seatmaps, timetables, a tournament system, a shop, newsposts,
recurring events and more!

## Features

* Ticketing System with QR Code Scanner for checking in at the event
* General Purpose Sop to sell tickets, merchandise, food, etc.
* Tournament System which can be used independently from a LAN party
* Newspost / Blogging system with markdown
* Side-Events with multiple dates
* Dynamic content pages & URL redirects
* Fully customizable Topnav menu
* Achievements
* File uploads
* Customizable CSS in admin panel
* Dynamic homepage with customizable content blocks & startpage banners
* Sidebar with customizable infoboxes
* Featureflags to disable not needed features
* JSON API for fetching data from the CMS
* OAuth2 provider

## Requirements

* [Docker Compose](https://docs.docker.com/compose/)

## Installation

We recommend using the included `docker-compose.yml` file to deploy the app with [docker compose](https://docs.docker.com/compose/).
Below are the steps needed to deploy the app in such a way:

### Install docker

First, you should install `docker` and `docker-compose` on your server. Follow the [official installation guides](https://docs.docker.com/get-docker/)
for your system to do this.

### Setup traefik

The provided docker compose setup uses traefik as a reverse proxy and to automatically configure your SSL certificates.
We suggest to use [this setup](https://github.com/conscribtor/docker-traefik-letsencrypt) on your server. Deploy
the traefik setup in a seperate folder on your server, following the instructions outlined in its repo.

### Setup L4N

First, create a new folder for the L4N setup on your server.
Create a file `.env`, and add the required env variables and their values into the file. See the file  `DEVELOPMENT.md` for a complete list of all env variables.
Which variables are needed might differ based on your configuration and needs.

After that, copy the file `docker-compose.yml` to your server. By default, it will use the `main` tag of the
image, which is the edge variant with the newest commits to the main branch. We recommend using a tagged version,
and as such you should replace `main` with the tag of the latest release.

After that, you can start L4N using `docker compose up -d`. This will pull the image, create the database,
run the migrations and prepare other required settings for L4N.

### Creating the first user

L4N contains a helpful script to create the first user from the CLI. This user has permission to edit
users, and as such you can then use this user to log-in to the admin panel, grant that user the other
required permissions and change settings in L4N.

To run this script, simply execute the `rake setup:user` task from the command line, or if you're using
the docker image, run the following:

```bash
docker exec -it <container_name> rake setup:user
```

where `<container_name>` is the name of the container, usually `l4n-web-1`.

### Custom installations

L4N can also be used in a custom setup, with your own docker compose setup. Please note however, that L4N requires Postgresql as the application database server. Currently it is not possible to use SQLite, mySQL or any other database as the application database server.
Also, please note that in development mode, SSL is required by the application, as
only connections over SSL are accepted, Strict-Transport-Security is enabled and cookies
are marked as secure.

## Useful commands

Sometimes, if might be useful to have to have some CLI commands at hand. While most of the settings in L4N can be configured in the admin panel or the `.env` File (or env variables, if you're not using the docker-compose file), sometimes you might need to access the logfiles, rails console or something else, so here are some useful commands:

| Task                              | Command in the L4N container      | Command from the host                                              |
| --------------------------------- | --------------------------------- | ------------------------------------------------------------------ |
| Restart the webserver (puma)      | `touch /app/tmp/restart.txt`      | `docker exec <container_name> touch /app/tmp/restart.txt`          |
| Access the Rails console          | `rails c`                         | `docker exec -it <container_name> rails c`                         |
| Read the logfiles as they come in | `tail -f /app/log/production.log` | `docker exec -it <container_name> tail -f /app/log/production.log` |

## Development

### Code style

To ensure a consistent code style, we use the following code analyzers / linters:

* [rubocop](https://github.com/rubocop/rubocop) for the Ruby source files
* [haml-lint](https://github.com/sds/haml-lint) for the haml view files
* [eslint](https://eslint.org/) for the Javascript source files

When you want to contribute to this project, please ensure that none of these 3 tools find any issues with your code (and if they do, follow the outlined suggestions to resolve the problems).

## Users

* [VSETH GECo](https://geco.ethz.ch)

Do you use L4N? Let us know and we'll put you on this list!
