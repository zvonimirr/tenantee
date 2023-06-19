FROM node:18 AS assets
WORKDIR /app
ADD . /app
RUN cd assets && npm install

FROM elixir:1.14.5
WORKDIR /app

ARG PHOENIX_VERSION

ENV DB_PREFIX=tenantee
ENV DB_HOST=tenantee.c5i8l6rfywpi.eu-central-1.rds.amazonaws.com
ENV DB_USERNAME=postgres
ENV DB_PASSWORD=postgres
ENV DATABASE_URL=ecto://postgres:postgres@tenantee.c5i8l6rfywpi.eu-central-1.rds.amazonaws.com:5432/tenantee
ENV MIX_ENV=prod
ENV PHX_HOST=localhost
ENV SECRET_KEY_BASE=MszGRNoUiJgxJH8Q8IgsTECBYYvxZg0eMszGRNoUiJgxJH8Q8IgsTECBYYvxZg0e

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
