defmodule TenanteeWeb.TenantViewTest do
  use TenanteeWeb.ConnCase, async: true

  import Phoenix.View

  @tenant %{
    id: 1,
    first_name: "John",
    last_name: "Doe",
    email: "jdoe@test.com",
    phone: "555-555-5555",
    inserted_at: ~N[2018-01-01 00:00:00],
    updated_at: ~N[2018-01-01 00:00:00]
  }

  @api_tenant @tenant
              |> Map.delete(:first_name)
              |> Map.delete(:last_name)
              |> Map.put_new(:name, @tenant.first_name <> " " <> @tenant.last_name)

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
      assert render(TenanteeWeb.TenantView, "show.json", %{tenant: @tenant}) == %{
               tenant: @api_tenant
             }
    end

    test "list of properties" do
      assert render(TenanteeWeb.TenantView, "show.json", %{tenants: [@tenant]}) == %{
               tenants: [@api_tenant]
             }
    end
  end
end
