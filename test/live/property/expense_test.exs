defmodule TenanteeWeb.PropertyExpenseLiveTest do
  use TenanteeWeb.ConnCase
  import Phoenix.LiveViewTest
  import Tenantee.Test.Factory.{Tenant, Property}
  import Tenantee.Test.Utils
  alias Tenantee.Entity.Tenant
  @endpoint TenanteeWeb.Endpoint

  test "renders", %{conn: conn} do
    {:ok, property} = generate_property()
    {:ok, _view, html} = live(conn, "/properties/#{property.id}/expenses")

    html = decode_html_entities(html)

    assert html =~ "Expenses"
  end

  test "adds expense successfully", %{conn: conn} do
    name = Faker.Company.En.name()
    description = Faker.Lorem.sentence()
    price = Faker.Commerce.price()

    {:ok, property} = generate_property()
    {:ok, tenant} = generate_tenant()
    Tenant.add_to_property(tenant.id, property.id)

    {:ok, view, _html} = live(conn, "/properties/#{property.id}/expenses")

    html =
      view
      |> form("#expense-add-form", %{
        name: name,
        description: description,
        amount: price,
        tenant_id: tenant.id
      })
      |> render_submit()
      |> decode_html_entities()

    assert html =~ name
    assert html =~ tenant.first_name
  end

  test "pays an expense successfully", %{conn: conn} do
    name = Faker.Company.En.name()
    description = Faker.Lorem.sentence()
    price = Faker.Commerce.price()

    {:ok, property} = generate_property()
    {:ok, view, _html} = live(conn, "/properties/#{property.id}/expenses")

    view
    |> form("#expense-add-form", %{name: name, description: description, amount: price})
    |> render_submit()

    assert view
           |> element("button", "Pay")
           |> render_click()
           |> decode_html_entities() =~ name
  end

  test "deletes expense successfully", %{conn: conn} do
    name = Faker.Company.En.name()
    description = Faker.Lorem.sentence()
    price = Faker.Commerce.price()

    {:ok, property} = generate_property()
    {:ok, view, _html} = live(conn, "/properties/#{property.id}/expenses")

    view
    |> form("#expense-add-form", %{name: name, description: description, amount: price})
    |> render_submit()

    view |> element(".bg-red-500") |> render_click()

    refute view |> element("#delete-expense") |> render_click() =~ name
  end

  test "cancels deletetion of expense successfully", %{conn: conn} do
    name = Faker.Company.En.name()
    description = Faker.Lorem.sentence()
    price = Faker.Commerce.price()

    {:ok, property} = generate_property()
    {:ok, view, _html} = live(conn, "/properties/#{property.id}/expenses")

    view
    |> form("#expense-add-form", %{name: name, description: description, amount: price})
    |> render_submit()

    view |> element(".bg-red-500") |> render_click()

    assert view
           |> element("button", "Cancel")
           |> render_click()
           |> decode_html_entities() =~ name
  end

  test "handles errors", %{conn: conn} do
    {:ok, property} = generate_property()
    {:ok, view, _html} = live(conn, "/properties/#{property.id}/expenses")

    assert view
           |> render_click("delete", %{id: -1}) =~ "Expense not found"

    assert view
           |> render_click("pay", %{id: -1}) =~ "Something went wrong"

    assert view
           |> render_click("do_delete", %{id: -1}) =~ "Something went wrong"
  end
end
