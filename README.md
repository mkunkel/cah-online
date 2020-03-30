# cah online

Project to create an online multiplayer Cards Against Humanity.
This is a Rails application, but has been set up to work exclusively in Docker. Further, make targets have been defined to provide easy commands for common tasks.

Prerequisites:
* docker
* docker-compose
* make

Defined make targets:
* `make dev` - Create a dev server, listening on port 3000, and associated database
* `make test` - Run tests
* `make build` - Create a docker image intended for production
* `make mock` - Create a server based on an image from `make build`, listening on port 3000
* `make check` - Run `make mock` and verify that the `/health-check` endpoint is working
* `make clean` - Remove unnecessary Docker containers and images
