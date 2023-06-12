FROM elixir:1.14.5

ARG PHOENIX_VERSION

ADD . /app

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new ${PHOENIX_VERSION}
RUN chmod +x /app/run.sh

WORKDIR /app

EXPOSE 4000
EXPOSE 443
