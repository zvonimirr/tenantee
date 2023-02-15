defmodule Tenantee.Repo.Migrations.AddCommunication do
  use Ecto.Migration

  def up do
    create table(:communication_channels) do
      add :type, :string, null: false
      add :value, :string, null: false
      add :tenant_id, references(:tenants, on_delete: :delete_all), null: false

      timestamps()
    end
  end

  def down do
    drop table(:communication_channels)
  end
end
