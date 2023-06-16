#!/bin/sh
# Adapted from Alex Kleissner's post, Running a Phoenix 1.3 project with docker-compose
# https://medium.com/@hex337/running-a-phoenix-1-3-project-with-docker-compose-d82ab55e43cf

set -e

# Set environment
export SECRET_KEY_BASE=$(mix phx.gen.secret)
export PHX_HOST=localhost
export MIX_ENV=prod

echo "\nMigrating the database..."

# Potentially Set up the database
mix ecto.create
mix ecto.migrate

echo "\nLaunching Phoenix web server..."
# Start the phoenix web server
mix phx.server
