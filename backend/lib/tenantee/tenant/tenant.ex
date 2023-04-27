defmodule Tenantee.Tenant do
  @moduledoc """
  This module contains all the necessary functions to manage tenants.
  """

  alias Tenantee.Stats
  alias Tenantee.Tenant.Schema
  alias Tenantee.Tenant.Communication.Schema, as: CommunicationSchema
  alias Tenantee.Repo
  import Ecto.Query

  @doc """
  Creates a new tenant.
  """
  def create_tenant(tenant) do
    case %Schema{}
         |> Schema.changeset(tenant)
         |> Repo.insert() do
      {:ok, tenant} ->
        {:ok, load_associations(tenant)}

      # coveralls-ignore-start
      # TODO: Figure out how to test this
      {:error, error} ->
        {:error, error}
        # coveralls-ignore-end
    end
  end

  @doc """
  Gets a single tenant.
  """
  def get_tenant_by_id(id) do
    with tenant <- Repo.get(Schema, id) do
      if tenant, do: {:ok, load_associations(tenant)}, else: {:error, :not_found}
    end
  end

  @doc """
  Gets a list of all tenants.
  """
  def get_all_tenants do
    Repo.all(Schema) |> Enum.map(&load_associations/1)
  end

  @doc """
  Updates an existing tenant.
  """
  def update_tenant(id, attrs) do
    with {:ok, tenant} <- get_tenant_by_id(id),
         changeset <- Schema.changeset(tenant, attrs),
         {:ok, updated_tenant} <- Repo.update(changeset) do
      {:ok, load_associations(updated_tenant)}
    else
      {:error, :not_found} ->
        {:error, :not_found}
    end
  end

  @doc """
  Deletes an existing tenant.
  """
  def delete_tenant(id) do
    with {affected_rows, nil} <-
           from(t in Schema, where: t.id == ^id)
           |> Repo.delete_all() do
      if affected_rows > 0, do: {:ok, :deleted}, else: {:error, :not_found}
    end
  end

  @doc """
  Creates a new communication for a tenant.
  """
  def add_communication(id, type, value) do
    with {:ok, tenant} <- get_tenant_by_id(id),
         {:ok, updated_tenant} <-
           Schema.add_communication(tenant, %{
             type: type,
             value: value
           })
           |> Repo.update() do
      {:ok, load_associations(updated_tenant)}
    else
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Deletes an existing communication for a tenant.
  """
  def remove_communication(tenant_id, communication_id) do
    with {:ok, tenant} <- get_tenant_by_id(tenant_id),
         communication when not is_nil(communication) <-
           Repo.get(CommunicationSchema, communication_id),
         {:ok, updated_tenant} <-
           Schema.remove_communication(tenant, communication)
           |> Repo.update() do
      {:ok, load_associations(updated_tenant)}
    else
      {:error, error} -> {:error, error}
      nil -> {:error, :not_found}
    end
  end

  defp load_associations(tenant) do
    tenant
    |> Repo.preload([:communications, :properties])
    |> load_finances()
  end

  def load_finances(tenant) do
    tenant
    |> Map.put(:debt, Stats.get_debt(tenant))
    |> Map.put(:income, Stats.get_income(tenant))
  end
end
