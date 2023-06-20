defmodule Tenantee.Repo.Migrations.AddCommunicationChannels do
  use Ecto.Migration

  def up do
    create table(:communication_channels) do
      add :type, :string
      add :value, :string
      add :tenant_id, references(:tenants, on_delete: :delete_all)

      timestamps()
    end
  end

  def down do
    drop table(:communication_channels)
  end
end
