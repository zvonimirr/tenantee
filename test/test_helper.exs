# TODO: Redis is not sandboxed yet. Only override the config if
# it doesn't exist.
if is_nil(Tenantee.Config.get(:currency, nil)) do
  Tenantee.Config.set(:currency, :USD)
end

if is_nil(Tenantee.Config.get(:name, nil)) do
  Tenantee.Config.set(:name, "Tenantee")
end

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Tenantee.Repo, :manual)
