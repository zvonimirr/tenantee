defmodule TenanteeWeb.PropertyAddLiveTest do
  use TenanteeWeb.ConnCase
  import Phoenix.LiveViewTest
  import Tenantee.Test.Utils
  @endpoint TenanteeWeb.Endpoint

  test "renders", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/properties/new")

    assert html =~ "Create new property"
    assert html =~ "Name"
    assert html =~ "Address"
    assert html =~ "Price"
    assert html =~ "Description"
  end

  test "redirects to edit page after creation", %{conn: conn} do
    name = Faker.Company.En.name()
    address = Faker.Address.street_address()
    price = Faker.Commerce.price()

    {:ok, og_view, _html} = live(conn, "/properties/new")

    {:ok, _view, html} =
      og_view
      |> form("#property-add-form", %{name: name, address: address, price: price})
      |> render_submit()
      |> follow_redirect(conn)

    html = decode_html_entities(html)

    assert html =~ "Edit #{name}"
  end
end
