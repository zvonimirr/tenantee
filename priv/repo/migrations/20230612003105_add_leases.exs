defmodule Tenantee.Repo.Migrations.AddLeases do
  use Ecto.Migration

  def up do
    create table(:leases, primary_key: false) do
      add :tenant_id, references(:tenants, on_delete: :delete_all)
      add :property_id, references(:properties, on_delete: :delete_all)
    end

    create index(:leases, [:tenant_id, :property_id])
  end

  def down do
    drop index(:leases, [:tenant_id, :property_id])
    drop table(:leases)
  end
end
