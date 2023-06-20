defmodule TenanteeWeb.TenantListLiveTest do
  use TenanteeWeb.ConnCase
  alias Tenantee.Schema
  alias Tenantee.Repo
  alias Tenantee.Entity.{Tenant, Rent}
  import Phoenix.LiveViewTest
  import Tenantee.Test.Factory.{Property, Tenant}
  import Tenantee.Test.Utils
  @endpoint TenanteeWeb.Endpoint

  test "renders list of tenants", %{conn: conn} do
    {:ok, tenant} = generate_tenant()
    {:ok, _view, html} = live(conn, "/tenants")

    html = decode_html_entities(html)

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

    view
    |> render_click("cancel_delete")

    view
    |> element("button", "Delete")
    |> render_click()

    assert view
           |> render_click("do_delete", %{id: tenant.id}) =~ "Tenant deleted successfully"
  end

  test "pays rent through modal", %{conn: conn} do
    {:ok, tenant} = generate_tenant()
    {:ok, property} = generate_property()
    Tenant.add_to_property(tenant.id, property.id)
    {:ok, rent} = Rent.create(tenant.id, property.id)

    {:ok, _rent} =
      Schema.Rent.changeset(rent, %{due_date: Date.add(Date.utc_today(), -1)})
      |> Repo.update()

    {:ok, view, _html} = live(conn, "/tenants")

    assert view
           |> render_click("manage_rents", %{id: tenant.id}) =~ "Manage rents"

    assert view
           |> render_click("pay_rent", %{rent: rent.id}) =~ "Rent paid successfully"

    assert view
           |> render_click("pay_rent", %{rent: -1}) =~ "Something went wrong"
  end

  test "handles errors", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/tenants")

    assert view
           |> render_click("delete", %{id: -1}) =~ "Tenant not found"

    assert view
           |> render_click("do_delete", %{id: -1}) =~ "Tenant not found"

    assert view
           |> render_click("manage_rents", %{id: -1}) =~ "Tenant not found"
  end
end
