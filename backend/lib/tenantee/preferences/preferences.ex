defmodule Tenantee.Preferences do
  @moduledoc """
  This module contains all the necessary functions to manage the preferences.
  """
  alias Tenantee.Repo
  alias Tenantee.Preferences.Schema

  def get_preferences do
    Repo.all(Schema)
    |> Enum.uniq_by(& &1.name)
  end

  def get_preference(name, default \\ nil) do
    with preferences <- get_preferences(),
         [preference] <-
           preferences |> Enum.filter(fn p -> Atom.to_string(p.name) == name end),
         false <- is_nil(preference) do
      {:ok, preference}
    else
      _error -> {:ok, default}
    end
  end

  def set_preference(name, value) do
    case get_preference(name) do
      {:ok, nil} ->
        %Schema{}
        |> Schema.changeset(%{name: name, value: value})
        |> Repo.insert()

      {:ok, preference} ->
        preference
        |> Schema.changeset(%{value: value})
        |> Repo.update()
    end
  end
end
