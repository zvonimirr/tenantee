defmodule TenanteeWeb.PropertyAgreementAddTest do
  use TenanteeWeb.ConnCase
  import Phoenix.LiveViewTest
  import Tenantee.Test.Factory.Property
  import Tenantee.Test.Factory.Tenant
  alias Tenantee.Entity.Tenant
  @endpoint TenanteeWeb.Endpoint

  test "renders agreement add form", %{conn: conn} do
    {:ok, tenant} = generate_tenant()
    {:ok, property} = generate_property()
    Tenant.add_to_property(tenant.id, property.id)
    {:ok, view, html} = live(conn, "/properties")

    assert html =~ "Generate Agreement"

    {:ok, _view, html} =
      view
      |> element("abbr[title='Generate Agreement'] a")
      |> render_click()
      |> follow_redirect(conn)

    assert html =~ "Create new agreement"
  end

  test "creates an agreement", %{conn: conn} do
    {:ok, tenant} = generate_tenant()
    {:ok, property} = generate_property()
    Tenant.add_to_property(tenant.id, property.id)
    {:ok, view, _html} = live(conn, "/properties")

    {:ok, view, _html} =
      view
      |> element("abbr[title='Generate Agreement'] a")
      |> render_click()
      |> follow_redirect(conn)

    {:ok, _view, html} =
      view
      |> form("#agreement-form", %{
        tenant_name: "None",
        rent_amount: 1000,
        lease_term: 12,
        start_date: "2022-01-01",
        end_date: "2022-12-31",
        security_deposit: 1000,
        additional_terms: "No pets allowed"
      })
      |> render_submit()
      |> follow_redirect(conn)

    assert html =~ "agreement was created successfully"
  end
end
