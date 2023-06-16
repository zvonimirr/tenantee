FROM node:18 AS assets
WORKDIR /app
ADD . /app
RUN cd assets && npm install

FROM elixir:1.14.5

ARG PHOENIX_VERSION

ADD . /app

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new ${PHOENIX_VERSION}

WORKDIR /app

RUN rm -rf /app/assets
COPY --from=assets /app/assets /app/assets
RUN export MIX_ENV=prod
RUN mix deps.get
RUN mix phx.gen.cert
RUN mix assets.deploy

EXPOSE 4000
EXPOSE 443