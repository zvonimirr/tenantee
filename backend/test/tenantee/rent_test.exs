defmodule TenanteeWeb.RentTest do
  use TenanteeWeb.ConnCase

  setup %{conn: _conn} do
    %{id: property_id} = Tenantee.Factory.Property.insert()
    %{id: tenant_id} = Tenantee.Factory.Tenant.insert()

    {:ok, %{property_id: property_id, tenant_id: tenant_id}}
  end

  test "add_rent", %{conn: conn, property_id: property_id, tenant_id: tenant_id} do
    put(conn, "/api/properties/#{property_id}/tenants/#{tenant_id}")

    Tenantee.Rent.Worker.perform(%Oban.Job{})

    conn = get(conn, "/api/rent")
    [rent] = json_response(conn, 200)["rents"]

    assert rent["property"]["id"] == property_id
    assert rent["tenant"]["id"] == tenant_id
  end
end
