defmodule TenanteeWeb.TenantListLiveTest do
  use TenanteeWeb.ConnCase
  import Phoenix.LiveViewTest
  import Tenantee.Test.Factory.Tenant
  @endpoint TenanteeWeb.Endpoint

  test "renders list of tenants", %{conn: conn} do
    {:ok, tenant} = generate_tenant()
    {:ok, _view, html} = live(conn, "/tenants")

    assert html =~ "Manage tenants"
    assert html =~ tenant.first_name
    assert html =~ tenant.last_name
  end

  test "deletes tenant through modal", %{conn: conn} do
    {:ok, tenant} = generate_tenant()

    {:ok, view, _html} = live(conn, "/tenants")

    assert view
           |> element("button", "Delete")
           |> render_click() =~ "Are you sure?"

    assert view
           |> render_click("do_delete", %{id: tenant.id}) =~ "Tenant deleted successfully"
  end
end
