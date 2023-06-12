defmodule Tenantee.Entity.Tenant do
  @moduledoc """
  Helper functions for tenants.
  """
  alias Tenantee.Entity.Property
  alias Tenantee.Schema.Tenant, as: Schema
  alias Tenantee.Repo

  @doc """
  Returns all tenants.
  """
  @spec all() :: [Schema.t()]
  def all() do
    Repo.all(Schema)
    |> Repo.preload([:properties, :rents])
  end

  @doc """
  Gets a tenant by id.
  """
  @spec get(integer()) :: {:ok, Schema.t()} | {:error, String.t()}
  def get(id) do
    case Repo.get(Schema, id) do
      nil ->
        {:error, "Tenant not found."}

      tenant ->
        {:ok, Repo.preload(tenant, [:properties, :rents])}
    end
  end

  @doc """
  Deletes a tenant by id.
  """
  @spec delete(integer()) :: :ok | {:error, String.t()}
  def delete(id) do
    with {:ok, tenant} <- get(id),
         {:ok, _} <- Repo.delete(tenant) do
      :ok
    end
  end

  @doc """
  Creates a tenant.
  """
  @spec create(map()) :: {:ok, Schema.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    Schema.changeset(%Schema{}, attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tenant by id.
  """
  @spec update(integer(), map()) :: :ok | {:error, Ecto.Changeset.t() | String.t()}
  def update(id, attrs) do
    with {:ok, tenant} <- get(id),
         changeset <- Schema.changeset(tenant, attrs),
         {:ok, _} <- Repo.update(changeset) do
      :ok
    end
  end

  @doc """
  Get a total number of tenants.
  """
  @spec count() :: integer()
  def count() do
    Repo.aggregate(Schema, :count, :id)
  end

  @doc """
  Add a tenant to a property.
  """
  @spec add_to_property(integer(), integer()) :: :ok | {:error, Ecto.Changeset.t() | String.t()}
  def add_to_property(id, property_id) do
    with {:ok, tenant} <- get(id),
         {:ok, property} <- Property.get(property_id),
         changeset <- Schema.set_properties(tenant, tenant.properties ++ [property]),
         {:ok, _} <- Repo.update(changeset) do
      :ok
    end
  end

  @doc """
  Remove a tenant from a property.
  """
  @spec remove_from_property(integer(), integer()) ::
          :ok | {:error, Ecto.Changeset.t() | String.t()}
  def remove_from_property(id, property_id) do
    with {:ok, tenant} <- get(id),
         {:ok, property} <- Property.get(property_id),
         changeset <-
           Schema.set_properties(
             tenant,
             remove_property_from_list(tenant.properties, property.id)
           ),
         {:ok, _} <- Repo.update(changeset) do
      :ok
    end
  end

  defp remove_property_from_list(properties, property_id) do
    Enum.filter(properties, fn property ->
      property.id != property_id
    end)
  end
end
