defmodule Tenantee.Repo.Migrations.AddExpenses do
  use Ecto.Migration

  def up do
    create table(:expenses) do
      add :name, :string
      add :description, :string, default: ""
      add :amount, :money_with_currency
      add :paid, :boolean, default: false

      add :property_id, references(:properties, on_delete: :delete_all)
      add :tenant_id, references(:tenants, on_delete: :nothing), null: true

      timestamps()
    end
  end

  def down do
    drop table(:expenses)
  end
end
