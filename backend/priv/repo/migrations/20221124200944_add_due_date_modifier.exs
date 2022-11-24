defmodule Tenantee.Repo.Migrations.AddDueDateModifier do
  use Ecto.Migration

  def up do
    alter table(:properties) do
      add :due_date_modifier, :integer, default: 5 * 24 * 60 * 60
    end
  end

  def down do
    alter table(:properties) do
      remove :due_date_modifier
    end
  end
end
