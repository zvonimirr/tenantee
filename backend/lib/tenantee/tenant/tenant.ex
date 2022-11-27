defmodule Tenantee.Tenant do
  @moduledoc """
  This module contains all the necessary functions to manage tenants.
  """

  alias Tenantee.Tenant.Schema
  alias Tenantee.Repo
  import Ecto.Query

  @doc """
  Creates a new tenant.
  """
  def create_tenant(tenant) do
    with {:ok, tenant} <-
           %Schema{}
           |> Schema.changeset(tenant)
           |> Repo.insert() do
      {:ok, tenant}
    else
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Gets a single tenant.
  """
  def get_tenant_by_id(id) do
    with tenant <- Repo.get(Schema, id) do
      if tenant, do: {:ok, tenant}, else: {:error, :not_found}
    end
  end

  @doc """
  Gets a list of all tenants.
  """
  def get_all_tenants do
    Repo.all(Schema)
  end

  @doc """
  Updates an existing tenant.
  """
  def update_tenant(id, attrs) do
    with {:ok, tenant} <- get_tenant_by_id(id),
         changeset <- Schema.changeset(tenant, attrs),
         {:ok, updated_tenant} <- Repo.update(changeset) do
      {:ok, updated_tenant}
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
end
