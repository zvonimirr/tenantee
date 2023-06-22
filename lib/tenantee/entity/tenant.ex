defmodule Tenantee.Entity.Tenant do
  @moduledoc """
  Helper functions for tenants.
  """
  alias Tenantee.Entity.{Property, CommunicationChannel}
  alias Tenantee.Schema.Tenant, as: Schema
  alias Tenantee.Schema.Rent
  alias Tenantee.Repo
  import Ecto.Query

  @doc """
  Returns all tenants.
  """
  @spec all() :: [Schema.t()]
  def all() do
    Repo.all(Schema)
    |> Repo.preload([:properties])
    |> Enum.map(&preload_tenant/1)
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
        {:ok, preload_tenant(tenant)}
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
         changeset <- Schema.set_properties(tenant, [property | tenant.properties]),
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

  @doc """
  Add a communication channel to a tenant.

  No need to create a remove function because that's
  handled by the communication channel's delete function.
  """
  @spec add_communication_channel(integer(), map()) ::
          :ok | {:error, Ecto.Changeset.t() | String.t()}
  def add_communication_channel(id, attrs) do
    with {:ok, tenant} <- get(id),
         {:ok, channel} <- CommunicationChannel.create(attrs),
         changeset <-
           Schema.set_communication_channels(tenant, [channel | tenant.communication_channels]),
         {:ok, _} <- Repo.update(changeset) do
      :ok
    end
  end

  defp remove_property_from_list(properties, property_id) do
    Enum.filter(properties, fn property ->
      property.id != property_id
    end)
  end

  defp preload_tenant(tenant) do
    Repo.preload(
      tenant,
      [
        :properties,
        :communication_channels,
        rents: from(r in Rent, where: r.tenant_id == ^tenant.id, order_by: [desc: r.id])
      ]
    )
  end
end
