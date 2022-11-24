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
    |> Enum.map(&Repo.preload(&1, [:tenant, :property]))
  end

  @doc """
  Returns a list of all rents taking into account whether
  the rent is paid or not.
  """
  def get_rents_by_paid(paid \\ false) do
    Repo.all(from r in Schema, where: r.paid == ^paid)
    |> Enum.map(&Repo.preload(&1, [:tenant, :property]))
  end

  @doc """
  Returns a list of unpaid rents by property.
  """
  def get_unpaid_rents_by_property_id(property_id) do
    Repo.all(
      from r in Schema,
        where: r.property_id == ^property_id and r.paid == false
    )
    |> Enum.map(&Repo.preload(&1, :tenant))
  end

  @doc """
  Returns wheter a tenant has unpaid rents.
  """
  def get_unpaid_rents_by_tenant_id(tenant_id) do
    Repo.all(
      from r in Schema,
        where: r.tenant_id == ^tenant_id and r.paid == false
    )
    |> Enum.map(&Repo.preload(&1, :property))
  end

  @doc """
  Marks a rent as paid or unpaid.
  """
  def mark_rent(rent_id, paid \\ false) do
    with rent <- Repo.get(Schema, rent_id),
         false <- is_nil(rent) do
      rent
      |> Schema.changeset(%{paid: paid})
      |> Repo.update()
    end
  end
end
