defmodule TenanteeWeb.TenantEditLiveTest do
  use TenanteeWeb.ConnCase
  import Phoenix.LiveViewTest
  import Tenantee.Test.Factory.Tenant
  import Tenantee.Test.Utils
  @endpoint TenanteeWeb.Endpoint

  test "renders", %{conn: conn} do
    {:ok, tenant} = generate_tenant()
    {:ok, _view, html} = live(conn, "/tenants/#{tenant.id}")

    html = decode_html_entities(html)

    assert html =~ "Edit #{tenant.first_name} #{tenant.last_name}"
    assert html =~ "First name"
    assert html =~ "Last name"
  end

  test "updates successfully", %{conn: conn} do
    first_name = Faker.Person.first_name()
    last_name = Faker.Person.last_name()

    {:ok, tenant} = generate_tenant()
    {:ok, view, _html} = live(conn, "/tenants/#{tenant.id}")

    html =
      view
      |> element("#tenant-edit-form")
      |> render_submit(%{first_name: first_name, last_name: last_name})
      |> decode_html_entities()

    assert html =~ "Edit #{first_name} #{last_name}"
    assert html =~ "#{first_name} #{last_name} was updated successfully"
  end

  test "adds/removes a communication channel", %{conn: conn} do
    email = Faker.Internet.email()

    {:ok, tenant} = generate_tenant()

    {:ok, view, html} = live(conn, "/tenants/#{tenant.id}")

    assert html =~ "No communication channels found"

    assert view
           |> form("#communication-channel-add-form")
           |> render_submit(%{type: "email", value: email}) =~
             "Communication channel email was added successfully."

    assert view
           |> render() =~ email

    assert view
           |> element(".communication-channel button")
           |> render_click() =~ "Communication channel was deleted successfully."
  end
end
