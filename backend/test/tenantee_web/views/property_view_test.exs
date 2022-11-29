defmodule TenanteeWeb.PropertyViewTest do
  use TenanteeWeb.ConnCase, async: true

  import Phoenix.View

  @property %{
    id: 1,
    name: "Test Property",
    description: "Test Description",
    location: "Test Location",
    price: Money.new("100.00", :USD),
    tax_percentage: 0.1,
    inserted_at: ~N[2018-01-01 00:00:00],
    updated_at: ~N[2018-01-01 00:00:00],
    tenants: [],
    due_date_modifier: 0,
    monthly_revenue: Money.new("0.00", :USD)
  }

  test "renders error.json" do
    assert render(TenanteeWeb.PropertyView, "error.json", %{message: "oops"}) ==
             %{error: "oops"}
  end

  test "renders delete.json" do
    assert render(TenanteeWeb.PropertyView, "delete.json", %{}) ==
             %{message: "Property deleted"}
  end

  describe "renders show.json" do
    test "single property" do
      assert render(TenanteeWeb.PropertyView, "show.json", %{property: @property}) ==
               @property
    end

    test "list of properties" do
      assert render(TenanteeWeb.PropertyView, "show.json", %{properties: [@property]}) == %{
               properties: [@property]
             }
    end
  end
end
