defmodule Tenantee.Entity.Property do
  @moduledoc """
  Helper functions for properties.
  """
  alias Tenantee.Schema.Property, as: Schema
  alias Tenantee.Repo

  @doc """
  Returns all properties.
  """
  def all do
    Repo.all(Schema)
  end

  @doc """
  Gets a property by id.
  """
  def get(id) do
    case Repo.get(Schema, id) do
      nil -> {:error, "Property not found"}
      property -> {:ok, property}
    end
  end

  @doc """
  Deletes a property by id.
  """
  def delete(id) do
    with {:ok, property} <- get(id),
         {:ok, _} <- Repo.delete(property) do
      :ok
    end
  end
end
