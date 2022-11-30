defmodule Tenantee.Repo.Migrations.AddExpenses do
  use Ecto.Migration

  def up do
    create table(:expenses) do
      add :amount, :money_with_currency
      add :description, :string, default: ""
      add :property_id, references(:properties, on_delete: :delete_all)

      timestamps()
    end
  end

  def down do
    drop table(:expenses)
  end
end
