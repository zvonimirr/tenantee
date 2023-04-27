defmodule Tenantee.Rent do
  @moduledoc """
  This module contains all the necessary functions to manage rents.
  """

  alias Tenantee.Repo
  alias Tenantee.Rent.Schema
  import Ecto.Query

  @doc """
  Returns a list of all rents.
  """
  def get_all_rents do
    Repo.all(Schema)
    |> Enum.map(&load_associations/1)
  end

  @doc """
  Adds a new rent.
  """
  def add_rent(property, tenant, due_date) do
    case Schema.changeset(%Schema{}, %{
           property_id: property.id,
           tenant_id: tenant.id,
           due_date: due_date,
           paid: false
         })
         |> Repo.insert() do
      {:ok, rent} -> {:ok, load_associations(rent)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Returns a list of all rents taking into account whether
  the rent is paid or not.
  """
  def get_rents_by_paid(paid \\ false) do
    Repo.all(from r in Schema, where: r.paid == ^paid)
    |> Enum.map(&load_associations/1)
  end

  @doc """
  Returns a list of unpaid rents by property.
  """
  def get_unpaid_rents_by_property_id(property_id) do
    Repo.all(
      from r in Schema,
        where: r.property_id == ^property_id and r.paid == false
    )
    |> Enum.map(&load_associations/1)
  end

  @doc """
  Returns a list of all rents of a tenant.
  """
  def get_all_rents_by_tenant_id(tenant_id) do
    Repo.all(
      from r in Schema,
        where: r.tenant_id == ^tenant_id
    )
    |> Enum.map(&load_associations/1)
  end

  @doc """
  Returns all unpaid rents of a tenant.
  """
  def get_unpaid_rents_by_tenant_id(tenant_id) do
    Repo.all(
      from r in Schema,
        where: r.tenant_id == ^tenant_id and r.paid == false
    )
    |> Enum.map(&load_associations/1)
  end

  @doc """
  Marks a rent as paid or unpaid.
  """
  def mark_rent(rent_id, paid \\ false) do
    with rent <- Repo.get(Schema, rent_id),
         false <- is_nil(rent),
         {:ok, rent} <-
           rent
           |> Schema.changeset(%{paid: paid})
           |> Repo.update() do
      {:ok, load_associations(rent)}
    else
      _ -> {:error, :not_found}
    end
  end

  defp load_associations(rent) do
    Repo.preload(rent, [:tenant, :property, property: :tenants])
  end
end
