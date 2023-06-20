defmodule TenanteeWeb.TenantAddLiveTest do
  use TenanteeWeb.ConnCase
  import Phoenix.LiveViewTest
  import Tenantee.Test.Utils
  @endpoint TenanteeWeb.Endpoint

  test "renders", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/tenants/new")

    assert html =~ "Create new tenant"
    assert html =~ "First name"
    assert html =~ "Last name"
  end

  test "redirects to edit page after creation", %{conn: conn} do
    first_name = Faker.Person.first_name()
    last_name = Faker.Person.last_name()

    {:ok, og_view, _html} = live(conn, "/tenants/new")

    {:ok, _view, html} =
      og_view
      |> form("#tenant-add-form", %{first_name: first_name, last_name: last_name})
      |> render_submit()
      |> follow_redirect(conn)

    html = decode_html_entities(html)

    assert html =~ "Edit #{first_name} #{last_name}"
  end

  test "handles errors", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/tenants/new")

    assert view
           |> form("#tenant-add-form", %{"first_name" => "", "last_name" => "Testic"})
           |> render_submit() =~ "Something went wrong"
  end
end
