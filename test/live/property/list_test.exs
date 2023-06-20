defmodule TenanteeWeb.PropertyListLiveTest do
  use TenanteeWeb.ConnCase
  import Phoenix.LiveViewTest
  import Tenantee.Test.Factory.{Property, Tenant}
  import Tenantee.Test.Utils
  @endpoint TenanteeWeb.Endpoint

  test "renders list of properties", %{conn: conn} do
    {:ok, property} = generate_property()
    {:ok, _view, html} = live(conn, "/properties")

    html = decode_html_entities(html)

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

    view
    |> render_click("cancel_delete")

    view
    |> element("button", "Delete")
    |> render_click()

    assert view
           |> render_click("do_delete", %{id: property.id}) =~ "Property deleted successfully"
  end

  test "opens lease modal", %{conn: conn} do
    {:ok, _property} = generate_property()
    {:ok, _tenant} = generate_tenant()

    {:ok, view, _html} = live(conn, "/properties")

    assert view
           |> element("button", "Manage tenants")
           |> render_click() =~
             "Toggling the checkbox will add or remove the tenant from the property."
  end

  test "toggles lease through modal", %{conn: conn} do
    {:ok, property} = generate_property()
    {:ok, tenant} = generate_tenant()

    {:ok, view, _html} = live(conn, "/properties")

    assert view
           |> render_click("toggle_lease", %{property: property.id, tenant: tenant.id}) =~
             "Lease updated successfully"

    assert view
           |> element("button", "Manage tenants")
           |> render_click()
           |> decode_html_entities() =~ "#{tenant.first_name} #{tenant.last_name}"
  end
end
