defmodule Tenantee.Repo.Migrations.SwitchToMoney do
  use Ecto.Migration

  def up do
    execute """
    CREATE TYPE public.money_with_currency AS (amount integer, currency varchar(3))
    """

    alter table(:properties) do
      remove :price
      remove :currency

      add :price, :money_with_currency
    end
  end

  def down do
    execute """
    DROP TYPE public.money_with_currency
    """

    alter table(:properties) do
      remove :price

      add :price, :integer
      add :currency, :string
    end
  end
end
