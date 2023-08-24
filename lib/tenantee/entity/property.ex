defmodule Tenantee.Entity.Property do
  @moduledoc """
  Helper functions for properties.
  """
  alias Tenantee.Config
  alias Tenantee.Entity.Tenant
  alias Tenantee.Schema.Property, as: Schema
  alias Tenantee.Repo

  @doc """
  Returns all properties.
  """
  @spec all() :: [Schema.t()]
  def all do
    Repo.all(Schema)
  end

  @doc """
  Gets a property by id.
  """
  @spec get(integer()) :: {:ok, Schema.t()} | {:error, String.t()}
  def get(id) do
    case Repo.get(Schema, id) do
      nil -> {:error, "Property not found"}
      property -> {:ok, preload(property)}
    end
  end

  @doc """
  Deletes a property by id.
  """
  @spec delete(integer()) :: :ok | {:error, String.t()}
  def delete(id) do
    with {:ok, property} <- get(id),
         {:ok, _} <- Repo.delete(property) do
      :ok
    end
  end

  @doc """
  Creates a property.
  """
  @spec create(map()) :: {:ok, Schema.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    Schema.changeset(%Schema{}, attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a property by id.
  """
  @spec update(integer(), map()) :: :ok | {:error, Ecto.Changeset.t() | String.t()}
  def update(id, attrs) do
    with {:ok, property} <- get(id),
         changeset <- Schema.changeset(property, attrs),
         {:ok, _} <- Repo.update(changeset) do
      :ok
    end
  end

  @doc """
  Gets a total number of properties.
  """
  @spec count() :: integer()
  def count() do
    Repo.aggregate(Schema, :count, :id)
  end

  @doc """
  Toggles the lease.
  """
  @spec toggle_lease(term(), term()) :: :ok | {:error, Ecto.Changeset.t() | String.t()}
  def toggle_lease(property, tenant) do
    if tenant.id in get_tenant_ids(property) do
      Tenant.remove_from_property(tenant.id, property.id)
    else
      Tenant.add_to_property(tenant.id, property.id)
    end
  end

  @doc """
  Calculates the price of a property (with tax).
  """
  @spec get_taxed_price(Money.t()) :: {:ok, Money.t()} | {:error, String.t()}
  def get_taxed_price(price) do
    with {:ok, tax} <- Config.get(:tax),
         {tax, ""} <- Float.parse(tax),
         {:ok, sub} <- Money.mult(price, tax / 100),
         {:ok, total} <- Money.sub(price, sub) do
      {:ok, total}
    else
      _error -> {:error, "Something went wrong"}
    end
  end

  defp get_tenant_ids(property) do
    property.tenants
    |> Enum.map(& &1.id)
  end

  defp preload(property) do
    Repo.preload(property, [
      :tenants,
      :expenses,
      expenses: [:tenant]
    ])
  end
end
