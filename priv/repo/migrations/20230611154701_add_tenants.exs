defmodule Tenantee.Repo.Migrations.AddTenants do
  use Ecto.Migration

  def up do
    create table(:tenants) do
      add :first_name, :string
      add :last_name, :string

      timestamps()
    end
  end

  def down do
    drop table(:tenants)
  end
end
