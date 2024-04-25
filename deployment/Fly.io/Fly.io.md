# Deploying to Fly.io

## Deployment
1. Go to `config/runtime.exs` and comment out the `https` and the `force_ssl` config so it looks like this:

```elixir
  config :tenantee, TenanteeWeb.Endpoint,
    url: [host: host, port: port, scheme: "http"],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: ip,
      port: port
    ],
    # https: [
    #   port: 443,
    #   cipher_suite: :strong,
    #   keyfile: "priv/cert/selfsigned_key.pem",
    #   certfile: "priv/cert/selfsigned.pem"
    # ],
    secret_key_base: secret_key_base

  # config :tenantee, TenanteeWeb.Endpoint, force_ssl: [hsts: true]
```

The reason for not using HTTPS is because Fly will provide it for you.

To deploy Tenantee on Fly.io follow these steps:
1. Remove or rename the default Dockerfile 
2. Rename Dockerfile.fly to Dockerfile
3. Run `flyctl launch`
4. When asked about the database, say yes
5. When asked about Valkey, say yes
6. When asked to deploy now, don't do it (yet)
7. Change the `force_https` key in `fly.toml` to false if experiencing issues.

If Valkey creation failed, go to the next section. If it didn't you can skip it.

## Valkey 

Sometimes Valkey creation may fail. 

You can get one from the Fly.io dashboard or from somehwere else just remember to set it as a secret:

`fly secrets set VALKEY_URL=...`

## Final step

Run `fly deploy`
