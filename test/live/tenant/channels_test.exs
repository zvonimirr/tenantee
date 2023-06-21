defmodule TenanteeWeb.TenantCommunicationChannelsLiveTest do
  use TenanteeWeb.ConnCase
  import Phoenix.LiveViewTest
  import Tenantee.Test.Factory.Tenant
  import Tenantee.Test.Utils

  test "renders", %{conn: conn} do
    {:ok, tenant} = generate_tenant()
    name = tenant.first_name <> " " <> tenant.last_name

    {:ok, _view, html} = live(conn, "/tenants/#{tenant.id}/channels")

    assert decode_html_entities(html) =~ "Communication channels for #{name}"

    assert decode_html_entities(html) =~ "No communication channels found"
  end

  test "adds/removes communication channels", %{conn: conn} do
    email = Faker.Internet.email()
    {:ok, tenant} = generate_tenant()

    {:ok, view, _html} = live(conn, "/tenants/#{tenant.id}/channels")

    assert view
           |> form("#communication-channel-add-form")
           |> render_submit(%{type: "email", value: email}) =~
             "Communication channel email was added successfully"

    assert view
           |> render() =~ email

    assert view
           |> element(".communication-channel button.bg-red-500")
           |> render_click() =~ "Communication channel was deleted successfully."

    assert view
           |> form("#communication-channel-add-form")
           |> render_submit(%{type: "email", value: ""}) =~ "Something went wrong"
  end
end
