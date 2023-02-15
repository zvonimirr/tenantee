defmodule TenanteeWeb.TenantViewTest do
  use TenanteeWeb.ConnCase, async: true
  import Phoenix.View

  @tenant %{
    id: 1,
    first_name: "John",
    last_name: "Doe"
  }

  @api_tenant @tenant
              |> Map.delete(:first_name)
              |> Map.delete(:last_name)
              |> Map.put_new(:name, @tenant.first_name <> " " <> @tenant.last_name)
              |> Map.put_new(:unpaid_rents, [])
              |> Map.put_new(:properties, [])

  test "renders error.json" do
    assert render(TenanteeWeb.TenantView, "error.json", %{message: "oops"}) ==
             %{error: "oops"}
  end

  test "renders delete.json" do
    assert render(TenanteeWeb.TenantView, "delete.json", %{}) ==
             %{message: "Tenant deleted"}
  end

  describe "renders show.json" do
    test "single property" do
      assert render(TenanteeWeb.TenantView, "show.json", %{tenant: @tenant}) ==
               @api_tenant
    end

    test "list of properties" do
      assert render(TenanteeWeb.TenantView, "show.json", %{tenants: [@tenant]}) == %{
               tenants: [@api_tenant]
             }
    end
  end
end
