defmodule Tenantee.Repo.Migrations.AddDefaultCurrency do
  use Ecto.Migration

  def up do
    execute("INSERT INTO preferences (name, value) VALUES ('default_currency', 'USD')")
  end

  def down do
    execute("DELETE FROM preferences WHERE name = 'default_currency'")
  end
end
