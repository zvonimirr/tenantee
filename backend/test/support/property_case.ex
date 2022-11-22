defmodule TenanteeWeb.PropertyCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      defp insert_property(conn) do
        post conn, "/api/properties", %{
          property: %{
            name: "Test Property",
            location: "Test Location",
            description: "Test Description",
            price: 100,
            currency: "USD"
          }
        }
      end
    end
  end
end
