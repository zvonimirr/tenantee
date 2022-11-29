# Tenantee
[![Coverage Status](https://coveralls.io/repos/github/zvonimirr/tenantee/badge.svg?branch=dev)](https://coveralls.io/github/zvonimirr/tenantee?branch=dev)
![GitHub issues](https://img.shields.io/github/issues-raw/zvonimirr/tenantee)
![GitHub pull requests](https://img.shields.io/github/issues-pr-raw/zvonimirr/tenantee)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/zvonimirr/tenantee/dev)
![GitHub](https://img.shields.io/github/license/zvonimirr/tenantee)
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-5-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

![Example](./example.gif)

Tenantee (pronounced "tenant-e") is a free and open-source management software aimed at landlords.

## Requirements
- Node (LTS)
- Elixir

## Running the application
### Backend
1. Go to [the backend directory](./backend)
2. Run `mix deps.get`
3. Run `mix phx.swagger.generate` (Optional, but Swagger won't work without it)
4. Configure the database in [config/dev.exs](./backend/config/dev.exs) (or prod.exs if running in prod mode)
5. Run `mix ecto.create`
6. Run `mix ecto.migrate`
7. Run `mix phx.server` (You can run in production mode by appending `MIX_ENV=prod` before the command)

Your backend should be running on [http://localhost:4000](http://localhost:4000)

You should have Swagger UI on [http://localhost:4000/api](http://localhost:4000/api)

Deploying to production? Please make sure to set all the necessary environment variables and see [https://hexdocs.pm/phoenix/deployment.html](https://hexdocs.pm/phoenix/deployment.html)

### Frontend
1. Go to [the frontend directory](./frontend)
2. Run `npm install`
3. Run `npm run build`

Your static build should be in the `dist` directory. 

You can either run `npm run  preview` or host it via Apache, Nginx or something similar.
### Docker
Running the application via Docker is simple and easy.
1. Run `docker-compose up -d`

Your backend should be running on [http://localhost:4000](http://localhost:4000) and the frontend should be available on [http://localhost](http://localhost)

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
      <td align="center"><a href="http://zvonimirr.github.io"><img src="https://avatars.githubusercontent.com/u/18758022?v=4?s=100" width="100px;" alt="Zvonimir Rudinski"/><br /><sub><b>Zvonimir Rudinski</b></sub></a><br /><a href="#ideas-zvonimirr" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/zvonimirr/tenantee/commits?author=zvonimirr" title="Documentation">📖</a> <a href="#projectManagement-zvonimirr" title="Project Management">📆</a> <a href="https://github.com/zvonimirr/tenantee/commits?author=zvonimirr" title="Tests">⚠️</a> <a href="https://github.com/zvonimirr/tenantee/commits?author=zvonimirr" title="Code">💻</a></td>
      <td align="center"><a href="https://github.com/kovaj024"><img src="https://avatars.githubusercontent.com/u/35566682?v=4?s=100" width="100px;" alt="Andrej Kovačić"/><br /><sub><b>Andrej Kovačić</b></sub></a><br /><a href="https://github.com/zvonimirr/tenantee/commits?author=kovaj024" title="Code">💻</a></td>
      <td align="center"><a href="https://github.com/jvince"><img src="https://avatars.githubusercontent.com/u/8256496?v=4?s=100" width="100px;" alt="jvince"/><br /><sub><b>jvince</b></sub></a><br /><a href="https://github.com/zvonimirr/tenantee/commits?author=jvince" title="Code">💻</a></td>
      <td align="center"><a href="https://github.com/lukaevet"><img src="https://avatars.githubusercontent.com/u/108657761?v=4?s=100" width="100px;" alt="Luka Evetovic"/><br /><sub><b>Luka Evetovic</b></sub></a><br /><a href="https://github.com/zvonimirr/tenantee/commits?author=lukaevet" title="Code">💻</a></td>
      <td align="center"><a href="https://github.com/MilaFazekas"><img src="https://avatars.githubusercontent.com/u/79193172?v=4?s=100" width="100px;" alt="Milly"/><br /><sub><b>Milly</b></sub></a><br /><a href="https://github.com/zvonimirr/tenantee/issues?q=author%3AMilaFazekas" title="Bug reports">🐛</a> <a href="https://github.com/zvonimirr/tenantee/commits?author=MilaFazekas" title="Code">💻</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

## Sponsoring

<a href='https://ko-fi.com/P5P4GKOBP' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi5.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
