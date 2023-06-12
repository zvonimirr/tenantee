defmodule Tenantee.Entity.Tenant do
  @moduledoc """
  Helper functions for tenants.
  """
  alias Tenantee.Schema.Tenant, as: Schema
  alias Tenantee.Repo

  @doc """
  Returns all tenants.
  """
  @spec all() :: [Schema.t()]
  def all() do
    Repo.all(Schema)
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
        {:ok, tenant}
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
  @spec create(map()) :: {:ok, Schema.t()} | {:error, String.t()}
  def create(attrs) do
    Schema.changeset(%Schema{}, attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tenant by id.
  """
  @spec update(integer(), map()) :: :ok | {:error, String.t()}
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
end
