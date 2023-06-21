defmodule Tenantee.Repo.Migrations.AddPropertyToRent do
  use Ecto.Migration

  def up do
    alter table(:rents) do
      add :property_id, references(:properties, on_delete: :delete_all)
    end
  end

  def down do
    alter table(:rents) do
      remove :property_id
    end
  end
end
