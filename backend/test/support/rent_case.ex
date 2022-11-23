defmodule TenanteeWeb.RentCase do
  @moduledoc """
  This module defines a test case that can be used with tests that require
  rent to be set up.
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Tenantee.Repo
      alias Tenantee.Rent.Schema

      defp insert_rent(property_id, tenant_id) do
        Repo.insert!(%Schema{
          property_id: property_id,
          tenant_id: tenant_id
        })
      end
    end
  end
end
