defmodule TenanteeWeb.RentTest do
  use TenanteeWeb.ConnCase
  use TenanteeWeb.TenantCase
  use TenanteeWeb.RentCase

  setup %{conn: conn} do
    %{id: property_id} = Tenantee.Factory.Property.insert()

    tenant_conn = insert_tenant(conn)
    tenant_id = json_response(tenant_conn, 201)["id"]

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
