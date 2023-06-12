defmodule Tenantee.Entity.Rent do
  @moduledoc """
  Helper functions for rents.
  """
  alias Tenantee.Schema.Rent, as: Schema
  alias Tenantee.Entity.{Tenant, Property}
  alias Tenantee.Repo
  import Ecto.Query, only: [from: 2]

  @doc """
  Creates a new rent.
  """
  @spec create(integer(), integer()) ::
          {:ok, Schema.t()} | {:error, Ecto.Changeset.t() | String.t()}
  def create(tenant_id, property_id) do
    with {:ok, tenant} <- Tenant.get(tenant_id),
         {:ok, property} <- Property.get(property_id) do
      Schema.changeset(%Schema{}, %{
        amount: property.price,
        # TODO: make this configurable
        due_date: Date.utc_today() |> Date.add(1),
        tenant_id: tenant.id,
        property_id: property.id
      })
      |> Repo.insert()
    end
  end

  @doc """
  Gets a number of unpaid rents.
  """
  @spec total_unpaid(integer()) :: integer()
  def total_unpaid(tenant_id) do
    from(r in Schema, where: r.tenant_id == ^tenant_id and r.paid == false)
    |> Repo.all()
    |> Enum.count()
  end
end
