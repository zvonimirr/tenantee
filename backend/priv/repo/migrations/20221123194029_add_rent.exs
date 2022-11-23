defmodule Tenantee.Repo.Migrations.AddRent do
  use Ecto.Migration

  def up do
    create table(:rent) do
      add :due_date, :date, default: fragment("now()")
      add :paid, :boolean, default: false
      add :tenant_id, references(:tenants, on_delete: :delete_all)
      add :property_id, references(:properties, on_delete: :delete_all)

      timestamps()
    end
  end

  def down do
    drop table(:rent)
  end
end
