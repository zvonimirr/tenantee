FROM elixir:1.14.2

ARG PHOENIX_VERSION

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new ${PHOENIX_VERSION}

WORKDIR /app
EXPOSE 4000
EXPOSE 443
