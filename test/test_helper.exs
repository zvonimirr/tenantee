if is_nil(Tenantee.Config.get(:currency, nil)) do
  Tenantee.Config.set(:currency, :USD)
end

if is_nil(Tenantee.Config.get(:name, nil)) do
  Tenantee.Config.set(:name, "Tenantee")
end

if is_nil(Tenantee.Config.get(:tax, nil)) do
  Tenantee.Config.set(:tax, 0.1)
end

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Tenantee.Repo, :manual)
