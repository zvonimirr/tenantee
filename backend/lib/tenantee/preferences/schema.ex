defmodule Tenantee.Preferences.Schema do
  @moduledoc """
  This module defines the schema for the preferences table.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Tenantee.Preferences.PreferenceName

  schema "preferences" do
    field :name, PreferenceName
    field :value, :string
  end

  def changeset(preference, attrs) do
    preference
    |> cast(attrs, [:name, :value])
    |> validate_required([:name, :value])
  end
end
