defmodule Tenantee.Repo.Migrations.AddTaxPercentage do
  use Ecto.Migration

  def up do
    alter table(:properties) do
      add :tax_percentage, :decimal, precision: 5, scale: 2, default: 0.0
    end
  end

  def down do
    alter table(:properties) do
      remove :tax_percentage
    end
  end
end
