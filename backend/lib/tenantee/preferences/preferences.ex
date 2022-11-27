defmodule Tenantee.Preferences do
  @moduledoc """
  This module contains all the necessary functions to manage the preferences.
  """
  alias Tenantee.Repo
  alias Tenantee.Preferences.Schema

  def get_preferences do
    Repo.all(Schema)
  end

  def get_preference(name, default \\ nil) do
    case Repo.get_by(Schema, name: name) do
      nil -> {:ok, default}
      preference -> {:ok, preference}
    end
  end

  def set_preference(name, value) do
    try do
      case Repo.get_by(Schema, name: name) do
        nil ->
          %Schema{}
          |> Schema.changeset(%{name: name, value: value})
          |> Repo.insert()

        preference ->
          preference
          |> Schema.changeset(%{value: value})
          |> Repo.update()
      end
    rescue
      Ecto.Query.CastError -> {:error, "Invalid name"}
    end
  end
end
