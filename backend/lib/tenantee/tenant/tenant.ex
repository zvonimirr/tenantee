defmodule Tenantee.Tenant do
  @moduledoc """
  This module contains all the necessary functions to manage tenants.
  """

  alias Tenantee.Tenant.Schema
  alias Tenantee.Tenant.Communication.Schema, as: CommunicationSchema
  alias Tenantee.Repo
  import Ecto.Query

  @doc """
  Creates a new tenant.
  """
  def create_tenant(tenant) do
    %Schema{}
    |> Schema.changeset(tenant)
    |> Repo.insert()
  end

  @doc """
  Gets a single tenant.
  """
  def get_tenant_by_id(id) do
    with tenant <- Repo.get(Schema, id) do
      if tenant, do: {:ok, tenant |> Repo.preload(:communications)}, else: {:error, :not_found}
    end
  end

  @doc """
  Gets a list of all tenants.
  """
  def get_all_tenants do
    Repo.all(Schema) |> Repo.preload(:communications)
  end

  @doc """
  Updates an existing tenant.
  """
  def update_tenant(id, attrs) do
    with {:ok, tenant} <- get_tenant_by_id(id),
         changeset <- Schema.changeset(tenant, attrs),
         {:ok, updated_tenant} <- Repo.update(changeset) do
      {:ok, updated_tenant |> Repo.preload(:communications)}
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
    with {:ok, tenant} <- get_tenant_by_id(id) do
      Schema.add_communication(tenant, %{
        type: type,
        value: value
      })
      |> Repo.update()
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
           Repo.get(CommunicationSchema, communication_id) do
      Schema.remove_communication(tenant, communication)
      |> Repo.update()
    else
      {:error, error} -> {:error, error}
      nil -> {:error, :not_found}
    end
  end
end
