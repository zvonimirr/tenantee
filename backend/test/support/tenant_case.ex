defmodule TenanteeWeb.TenantCase do
  @moduledoc """
  This module defines a test case that can be used with tests that require
  a tenant to be set up.
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      defp insert_tenant(conn) do
        post conn, "/api/tenants", %{
          first_name: "Test",
          last_name: "Tenant",
          email: "test@tenant.com"
        }
      end
    end
  end
end
