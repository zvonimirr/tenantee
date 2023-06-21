defmodule TenanteeWeb.TenantRentLiveTest do
  use TenanteeWeb.ConnCase
  import Phoenix.LiveViewTest
  import Tenantee.Test.Factory.{Tenant, Property}
  import Tenantee.Test.Utils
  alias Tenantee.Jobs.Rent, as: Job
  alias Tenantee.Schema.Rent, as: Schema
  alias Tenantee.Entity.Tenant
  alias Tenantee.Repo

  test "renders", %{conn: conn} do
    {:ok, tenant} = generate_tenant()
    name = tenant.first_name <> " " <> tenant.last_name

    {:ok, _view, html} = live(conn, "/tenants/#{tenant.id}/rents")

    assert decode_html_entities(html) =~ "Rents for #{name}"

    assert decode_html_entities(html) =~ "No rents found"
  end

  test "pays rent", %{conn: conn} do
    {:ok, property} = generate_property()
    {:ok, tenant} = generate_tenant()
    Tenant.add_to_property(tenant.id, property.id)
    Job.generate_rents()
    Job.generate_rents()

    {:ok, tenant} = Tenant.get(tenant.id)
    [rent1, rent2] = tenant.rents

    Repo.update(Schema.changeset(rent1, %{due_date: Date.utc_today() |> Date.add(-1)}))
    {:ok, tenant} = Tenant.get(tenant.id)

    {:ok, view, _html} = live(conn, "/tenants/#{tenant.id}/rents")

    assert view
           |> render_click("pay", %{"rent" => rent1.id})

    assert view
           |> render_click("pay", %{"rent" => rent2.id})
  end

  test "handle errors", %{conn: conn} do
    {:ok, tenant} = generate_tenant()

    {:ok, view, _html} = live(conn, "/tenants/#{tenant.id}/rents")

    assert view
           |> render_click("pay", %{"rent" => -1}) =~ "Something went wrong"
  end
end
