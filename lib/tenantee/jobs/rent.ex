defmodule Tenantee.Jobs.Rent do
  @moduledoc """
  Helper functions to be executed by Quantum
  """
  alias Tenantee.Config
  alias Tenantee.Entity.{Tenant, Rent}

  @doc """
  Generates a new rent for each tenant
  """
  @spec generate_rents() :: :ok
  def generate_rents() do
    if not Config.lacks_config?() do
      Tenant.all()
      |> Enum.filter(&(Enum.count(&1.properties) > 0))
      |> Enum.each(fn tenant ->
        Enum.each(tenant.properties, fn property ->
          Rent.create(tenant.id, property.id)
        end)
      end)
    end

    :ok
  end
end
