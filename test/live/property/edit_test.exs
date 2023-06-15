defmodule TenanteeWeb.PropertyEditLiveTest do
  use TenanteeWeb.ConnCase
  import Phoenix.LiveViewTest
  import Tenantee.Test.Factory.Property
  import Tenantee.Test.Utils
  @endpoint TenanteeWeb.Endpoint

  test "renders", %{conn: conn} do
    {:ok, property} = generate_property()
    {:ok, _view, html} = live(conn, "/properties/#{property.id}")

    html = decode_html_entities(html)

    assert html =~ "Edit #{property.name}"

    assert html =~ "Name"
    assert html =~ "Address"
    assert html =~ "Price"
    assert html =~ "Description"
  end

  test "updates successfully", %{conn: conn} do
    name = Faker.Company.En.name()
    address = Faker.Address.street_address()
    price = Faker.Commerce.price()

    {:ok, property} = generate_property()

    {:ok, view, _html} = live(conn, "/properties/#{property.id}")

    html =
      view
      |> element("#property-edit-form")
      |> render_submit(%{name: name, address: address, price: price})
      |> decode_html_entities()

    assert html =~ "Edit #{name}"
    assert html =~ "#{name} was updated successfully"
  end
end
