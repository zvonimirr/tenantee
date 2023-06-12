defmodule Tenantee.Repo.Migrations.AddPrice do
  use Ecto.Migration

  def up do
    alter table(:properties) do
      add :price, :money_with_currency
    end
  end

  def down do
    alter table(:properties) do
      remove :price
    end
  end
end
