FROM node:18 AS assets
WORKDIR /app
ADD . /app
RUN cd assets && npm install

FROM elixir:1.14.5
WORKDIR /app

ARG SECRET_KEY_BASE
ARG DATABASE_URL
ARG REDIS_URL
ARG PHX_HOST=localhost

ENV PHOENIX_VERSION=1.7.6
ENV MIX_ENV=prod

ADD . /app

RUN rm -rf /app/assets
COPY --from=assets /app/assets /app/assets

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new ${PHOENIX_VERSION}

RUN mix ecto.create && mix ecto.migrate
RUN mix phx.gen.cert
RUN mix assets.deploy

EXPOSE 443

CMD [ "mix", "phx.server" ]
