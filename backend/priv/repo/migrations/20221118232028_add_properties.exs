defmodule Tenantee.Repo.Migrations.AddProperties do
  use Ecto.Migration

  def up do
    create table("properties") do
      add :name, :string
      add :description, :string, default: ""
      add :location, :string
      add :price, :float
      add :currency, :string

      timestamps()
    end
  end

  def down do
    drop table("properties")
  end
end
