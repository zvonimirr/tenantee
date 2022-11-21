defmodule TenanteeWeb.TenantCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      defp insert_tenant(conn) do
        post conn, "/api/tenants", %{
          tenant: %{
            first_name: "Test",
            last_name: "Tenant",
            email: "test@tenant.com"
          }
        }
      end
    end
  end

  setup_all do
    :ok
  end

  setup do
    :ok
  end
end
