defmodule Tenantee.Repo.Migrations.RemovePhoneAndEmail do
  use Ecto.Migration

  def up do
    alter table(:tenants) do
      remove :phone
      remove :email
    end
  end

  def down do
    alter table(:tenants) do
      add :phone, :string, default: ""
      add :email, :string, default: ""
    end
  end
end
