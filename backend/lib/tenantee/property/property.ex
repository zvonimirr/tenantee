defmodule Tenantee.Property do
  @moduledoc """
  This module contains all the necessary functions to manage properties.
  """

  alias Tenantee.Repo
  alias Tenantee.Property.Schema
  alias Tenantee.Tenant
  alias Tenantee.Tenant.Schema, as: TenantSchema
  import Ecto.Query

  @doc """
  Creates a new property.
  """
  def create_property(attrs) do
    with {:ok, property} <-
           %Schema{}
           |> Schema.changeset(attrs)
           |> Repo.insert() do
      {:ok, Repo.preload(property, [:tenants, :expenses])}
    end
  end

  @doc """
  Gets a single property.
  """
  def get_property(id) do
    with property <- Repo.get(Schema, id) do
      if property,
        do: {:ok, Repo.preload(property, [:tenants, :expenses])},
        else: {:error, :not_found}
    end
  end

  @doc """
  Gets a list of all the properties.
  """
  def get_all_properties do
    Repo.all(Schema)
    |> Repo.preload([:tenants, :expenses])
  end

  @doc """
  Updates an existing property.
  """
  def update_property(id, attrs) do
    with {:ok, property} <-
           get_property(id),
         changeset <-
           Schema.changeset(property, attrs),
         {:ok, updated_property} <- Repo.update(changeset) do
      {:ok, Repo.preload(updated_property, [:tenants, :expenses])}
    end
  end

  @doc """
  Deletes an existing property.
  """
  def delete_property(id) do
    with {affected_rows, nil} <-
           from(p in Schema, where: p.id == ^id)
           |> Repo.delete_all() do
      if affected_rows > 0, do: {:ok, :deleted}, else: {:error, :not_found}
    end
  end

  @doc """
  Adds an existing tenant to a property.
  """
  def add_tenant(property_id, tenant_id) do
    with {:ok, %Schema{} = property} <- get_property(property_id),
         {:ok, %TenantSchema{} = tenant} <- Tenant.get_tenant_by_id(tenant_id) do
      Schema.add_tenant(property, tenant)
      |> Repo.update()
    else
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Removes a tenant from the property.
  """
  def remove_tenant(property_id, tenant_id) do
    with {:ok, %Schema{} = property} <- get_property(property_id),
         {:ok, %TenantSchema{} = tenant} <- Tenant.get_tenant_by_id(tenant_id) do
      Schema.remove_tenant(property, tenant)
      |> Repo.update()
    else
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Gets all properties that a tenant is associated with.
  """
  def get_properties_of_tenant(tenant_id) do
    get_all_properties()
    |> Enum.reject(&Enum.empty?(&1.tenants))
    |> Enum.filter(&Enum.any?(&1.tenants, fn tenant -> tenant.id == tenant_id end))
  end
end
