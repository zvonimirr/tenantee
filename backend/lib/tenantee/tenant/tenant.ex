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
    %Schema{}
    |> Schema.changeset(tenant)
    |> Repo.insert()
  end

  @doc """
  Gets a single tenant.
  """
  def get_tenant_by_id(id) do
    Repo.get(Schema, id)
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
    get_tenant_by_id(id)
    |> Schema.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an existing tenant.
  """
  def delete_tenant(id) do
    from(t in Schema, where: t.id == ^id)
    |> Repo.delete_all()
  end
end
