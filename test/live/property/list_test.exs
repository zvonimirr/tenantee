defmodule TenanteeWeb.PropertyListLiveTest do
  use TenanteeWeb.ConnCase
  import Phoenix.LiveViewTest
  import Tenantee.Test.Factory.Property
  @endpoint TenanteeWeb.Endpoint

  test "renders list of properties", %{conn: conn} do
    {:ok, property} = generate_property()
    {:ok, _view, html} = live(conn, "/properties")

    assert html =~ "Manage your properties"

    assert html =~ property.name
    assert html =~ property.address
  end

  test "deletes property through modal", %{conn: conn} do
    {:ok, property} = generate_property()

    {:ok, view, _html} = live(conn, "/properties")

    assert view
           |> element("button", "Delete")
           |> render_click() =~ "Are you sure?"

    assert view
           |> render_click("do_delete", %{id: property.id}) =~ "Property deleted successfully"
  end
end
