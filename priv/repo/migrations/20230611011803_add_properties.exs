defmodule Tenantee.Repo.Migrations.AddProperties do
  use Ecto.Migration

  def up do
    create table(:properties) do
      add :name, :string
      add :description, :string, default: ""
      add :address, :string

      timestamps()
    end
  end

  def down do
    drop table(:properties)
  end
end
