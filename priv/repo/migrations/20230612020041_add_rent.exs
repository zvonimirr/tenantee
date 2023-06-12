defmodule Tenantee.Repo.Migrations.AddRent do
  use Ecto.Migration

  def up do
    create table(:rents) do
      add :amount, :money_with_currency
      add :due_date, :date
      add :paid, :boolean, default: false

      add :tenant_id, references(:tenants, on_delete: :delete_all)

      timestamps()
    end
  end

  def down do
    drop table(:rents)
  end
end
