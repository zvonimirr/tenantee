defmodule Tenantee.Entity.Property do
  @moduledoc """
  Helper functions for properties.
  """
  alias Tenantee.Schema.Property, as: Schema
  alias Tenantee.Repo

  @doc """
  Returns all properties.
  """
  @spec all() :: [Schema.t()]
  def all do
    Repo.all(Schema)
  end

  @doc """
  Gets a property by id.
  """
  @spec get(String.t()) :: {:ok, Schema.t()} | {:error, String.t()}
  def get(id) do
    case Repo.get(Schema, id) do
      nil -> {:error, "Property not found"}
      property -> {:ok, property}
    end
  end

  @doc """
  Deletes a property by id.
  """
  @spec delete(String.t()) :: :ok | {:error, String.t()}
  def delete(id) do
    with {:ok, property} <- get(id),
         {:ok, _} <- Repo.delete(property) do
      :ok
    end
  end

  @doc """
  Creates a property.
  """
  @spec create(map()) :: {:ok, Schema.t()} | {:error, String.t()}
  def create(attrs) do
    Schema.changeset(%Schema{}, attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a property by id.
  """
  @spec update(String.t(), map()) :: :ok | {:error, String.t()}
  def update(id, attrs) do
    with {:ok, property} <- get(id),
         changeset <- Schema.changeset(property, attrs),
         {:ok, _} <- Repo.update(changeset) do
      :ok
    end
  end

  @doc """
  Gets a total number of properties.
  """
  @spec count() :: integer()
  def count() do
    Repo.aggregate(Schema, :count, :id)
  end
end
