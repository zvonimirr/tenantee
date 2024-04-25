import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :tenantee, Tenantee.Repo,
  username: "tenantee",
  password: "tenantee",
  hostname: "localhost",
  database: "tenantee_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tenantee, TenanteeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "UgTV0hx57JnRPUgwZzK6tEBssDUs4XV+mI8DtbVvah7C5JZQ6v+Tz3WOUGdEzfOV",
  server: false

# In test we don't send emails.
config :tenantee, Tenantee.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Configure Valkey
config :tenantee,
  valkey_connection_url: "valkey://:tenantee_valkey@localhost:6379"
