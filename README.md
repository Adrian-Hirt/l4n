# L4N

[![CI check](https://github.com/Adrian-Hirt/l4n/actions/workflows/ci.yml/badge.svg)](https://github.com/Adrian-Hirt/l4n/actions/workflows/ci.yml)
[![Edge docker image](https://github.com/Adrian-Hirt/l4n/actions/workflows/build_edge_docker.yml/badge.svg)](https://github.com/Adrian-Hirt/l4n/actions/workflows/build_edge_docker.yml)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

**The Readme is work in progress, please contact the maintainers if you should have any questions**

L4N is a CMS for managing LAN parties, featuring a ticketing system, seatmaps, timetables, a tournament system, a shop, newsposts,
recurring events and more!

## Installation

We recommend using the included `docker-compose` file to deploy the app with [docker compose](https://docs.docker.com/compose/).
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

### Custom installations

L4N can also be used in a custom setup, with your own docker compose setup. Please note however, that L4N requires Postgresql as the application database server. Currently it is not possible to use SQLite, mySQL or any other database as the application database server.

## Users

* [VSETH GECo](https://geco.ethz.ch)

Do you use L4N? Let us know and we'll put you on this list!
