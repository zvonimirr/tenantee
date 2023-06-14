defmodule TenanteeWeb.ConfigLiveTest do
  use TenanteeWeb.ConnCase
  import Phoenix.LiveViewTest
  import Tenantee.Test.Factory.Tenant
  @endpoint TenanteeWeb.Endpoint

  test "renders", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/settings")

    assert html =~ "Configuration"
    assert html =~ "Name"
    assert html =~ "Currency"
    assert html =~ "Save"
  end

  test "saves the configuration", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/settings")

    assert view
           |> form("form", %{name: "Test", currency: "EUR"})
           |> render_submit() =~ "Configuration saved successfully!"
  end

  test "enables the save button after inputting a name", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/settings")

    assert view
           |> element("[name='name']")
           |> render_change(%{"_target" => "name", "name" => "Test Name"}) =~ "Test Name"

    assert view
           |> element("[name='name']")
           |> render_change(%{"_target" => "name", "name" => "Test Name"})
           |> Floki.parse_fragment!()
           |> Floki.find("button")
           |> List.first()
           |> Floki.attribute("disabled") == []
  end

  test "disables the currency select when we have a tenant or property", %{conn: conn} do
    generate_tenant()
    {:ok, view, _html} = live(conn, "/settings")

    assert view
           |> element("select")
           |> render()
           |> Floki.parse_fragment!()
           |> Floki.find("select")
           |> List.first()
           |> Floki.attribute("disabled") == ["disabled"]
  end
end
