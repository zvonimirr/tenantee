defmodule TenanteeWeb.PropertyCase do
  @moduledoc """
  This module defines a test case that can be used with tests that require
  a property to be set up.
  """
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
