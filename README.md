# Tenantee
[![Coverage Status](https://coveralls.io/repos/github/zvonimirr/tenantee/badge.svg?branch=dev)](https://coveralls.io/github/zvonimirr/tenantee?branch=dev)
![GitHub issues](https://img.shields.io/github/issues-raw/zvonimirr/tenantee)
![GitHub pull requests](https://img.shields.io/github/issues-pr-raw/zvonimirr/tenantee)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/zvonimirr/tenantee/dev)
![GitHub](https://img.shields.io/github/license/zvonimirr/tenantee)
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-8-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

Tenantee (pronounced "tenant-e") is a free and open-source management software aimed at landlords.

## Requirements
- Elixir
- PostgreSQL
- Redis

## Running the application
1. Run `mix deps.get`
2. Configure the database in [config/dev.exs](./backend/config/dev.exs) (or prod.exs if running in prod mode)
3. Run `mix ecto.create`
4. Run `mix ecto.migrate`
5. Run `mix phx.server` (You can run in production mode by appending `MIX_ENV=prod` before the command)

Your app should be running on [http://localhost:4000](http://localhost:4000)

### Docker Compose
Running the application via Docker Compose is simple and easy.
1. Run `docker-compose up db -d`
2. Run `docker-compose up redis -d`
3. Run `docker-compose build`
3. Run `docker-compose up app -d`

Your app should be running on [https://localhost](https://localhost)

### Docker (without Compose)
Running the application without Docker Compose requires a bit more config.
For ease-of-use, create a `build.sh` file and paste:
```sh
#!/bin/bash

export SECRET_KEY_BASE=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 64 ; echo '')
export DATABASE_URL=<ecto connection string>
export REDIS_URL=<redis connection string>
export PHX_HOST=localhost

docker build -t tenantee-app . \
    --build-arg SECRET_KEY_BASE=$SECRET_KEY_BASE \
    --build-arg DATABASE_URL=$DATABASE_URL \
    --build-arg REDIS_URL=$REDIS_URL

docker run -d \
    --env SECRET_KEY_BASE=$SECRET_KEY_BASE \
    --env DATABASE_URL=$DATABASE_URL \
    --env PHX_HOST=$PHX_HOST \
    --env REDIS_URL=$REDIS_URL \
    -p 443:443 \
    tenantee-app

echo $SECRET_KEY_BASE
```

Then run:
1. `chmod +x build.sh`
2. `./build.sh`

Your app should be running on [https://localhost](https://localhost)

## Production
Deploying to production? Take a look at the guides [here](deployment).

Not satisfied? Take a look: [https://hexdocs.pm/phoenix/deployment.html](https://hexdocs.pm/phoenix/deployment.html)

## Contributing
If you wish to contribute to the project, please refer to the [contributing guide](./CONTRIBUTING.md) first.

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="http://zvonimirr.github.io"><img src="https://avatars.githubusercontent.com/u/18758022?v=4?s=100" width="100px;" alt="Zvonimir Rudinski"/><br /><sub><b>Zvonimir Rudinski</b></sub></a><br /><a href="#ideas-zvonimirr" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/zvonimirr/tenantee/commits?author=zvonimirr" title="Documentation">📖</a> <a href="#projectManagement-zvonimirr" title="Project Management">📆</a> <a href="https://github.com/zvonimirr/tenantee/commits?author=zvonimirr" title="Tests">⚠️</a> <a href="https://github.com/zvonimirr/tenantee/commits?author=zvonimirr" title="Code">💻</a> <a href="#infra-zvonimirr" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/kovaj024"><img src="https://avatars.githubusercontent.com/u/35566682?v=4?s=100" width="100px;" alt="Andrej Kovačić"/><br /><sub><b>Andrej Kovačić</b></sub></a><br /><a href="https://github.com/zvonimirr/tenantee/commits?author=kovaj024" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/jvince"><img src="https://avatars.githubusercontent.com/u/8256496?v=4?s=100" width="100px;" alt="jvince"/><br /><sub><b>jvince</b></sub></a><br /><a href="https://github.com/zvonimirr/tenantee/commits?author=jvince" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/lukaevet"><img src="https://avatars.githubusercontent.com/u/108657761?v=4?s=100" width="100px;" alt="Luka Evetovic"/><br /><sub><b>Luka Evetovic</b></sub></a><br /><a href="https://github.com/zvonimirr/tenantee/commits?author=lukaevet" title="Code">💻</a> <a href="#infra-lukaevet" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="https://github.com/zvonimirr/tenantee/commits?author=lukaevet" title="Documentation">📖</a> <a href="https://github.com/zvonimirr/tenantee/issues?q=author%3Alukaevet" title="Bug reports">🐛</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/MilaFazekas"><img src="https://avatars.githubusercontent.com/u/79193172?v=4?s=100" width="100px;" alt="Milly"/><br /><sub><b>Milly</b></sub></a><br /><a href="https://github.com/zvonimirr/tenantee/issues?q=author%3AMilaFazekas" title="Bug reports">🐛</a> <a href="https://github.com/zvonimirr/tenantee/commits?author=MilaFazekas" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://mithin.hashnode.dev"><img src="https://avatars.githubusercontent.com/u/109973775?v=4?s=100" width="100px;" alt="MITHIN DEV "/><br /><sub><b>MITHIN DEV </b></sub></a><br /><a href="https://github.com/zvonimirr/tenantee/commits?author=mithindev" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://akosszarvak.com/"><img src="https://avatars.githubusercontent.com/u/43302360?v=4?s=100" width="100px;" alt="Szarvák Ákos"/><br /><sub><b>Szarvák Ákos</b></sub></a><br /><a href="https://github.com/zvonimirr/tenantee/commits?author=akosszarvak" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Steve0012345"><img src="https://avatars.githubusercontent.com/u/66390650?v=4?s=100" width="100px;" alt="Steve Shema N."/><br /><sub><b>Steve Shema N.</b></sub></a><br /><a href="https://github.com/zvonimirr/tenantee/commits?author=Steve0012345" title="Code">💻</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

## Sponsoring

<a href='https://ko-fi.com/P5P4GKOBP' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi5.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
