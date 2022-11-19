defmodule Tenantee.Repo.Migrations.AddPropertyTenants do
  use Ecto.Migration

  def change do
    create table(:property_tenants) do
      add :property_id, references(:properties, on_delete: :delete_all)
      add :tenant_id, references(:tenants, on_delete: :delete_all)
    end

    create unique_index(:property_tenants, [:property_id, :tenant_id])
  end
end
