defmodule Tenantee.Repo.Migrations.AddPreferences do
  use Ecto.Migration
  alias Tenantee.Preferences.PreferenceName

  def up do
    PreferenceName.create_type()

    create table(:preferences) do
      add :name, :preference_name
      add :value, :string
    end
  end

  def down do
    drop table(:preferences)

    PreferenceName.drop_type()
  end
end
