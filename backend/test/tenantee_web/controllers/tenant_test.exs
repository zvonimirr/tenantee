defmodule TenanteeWeb.TenantControllerTest do
  use TenanteeWeb.ConnCase
  use TenanteeWeb.PropertyCase
  use TenanteeWeb.TenantCase
  use TenanteeWeb.RentCase

  test "POST /api/tenants", %{conn: conn} do
    conn = insert_tenant(conn)
    failure_conn = post(conn, "/api/tenants")

    assert json_response(conn, 201)["id"] != nil
    assert json_response(failure_conn, 400) == %{"error" => "Invalid params"}
  end

  test "GET /api/tenants/:id", %{conn: conn} do
    conn = insert_tenant(conn)
    id = json_response(conn, 201)["id"]

    conn = get(conn, "/api/tenants/#{id}")

    assert json_response(conn, 200)["id"] == id
  end

  test "GET /api/tenants", %{conn: conn} do
    insert_tenant(conn)

    conn = get(conn, "/api/tenants")

    assert json_response(conn, 200)["tenants"] != []
  end

  test "PATCH /api/tenants/:id", %{conn: conn} do
    conn = insert_tenant(conn)
    id = json_response(conn, 201)["id"]

    conn =
      patch(conn, "/api/tenants/#{id}", %{
        tenant: %{
          first_name: "Updated"
        }
      })

    failure_conn = patch(conn, "/api/tenants/#{id}", %{})

    failure2_conn =
      patch(conn, "/api/tenants/#{id + 1}", %{
        tenant: %{
          first_name: "Updated",
          last_name: "Updated",
          email: "Updated",
          phone: "Updated",
          property_id: "Updated",
          rent_id: "Updated"
        }
      })

    assert json_response(conn, 200)["name"] == "Updated Tenant"
    assert json_response(failure_conn, 400) == %{"error" => "Invalid params"}
    assert json_response(failure2_conn, 404) == %{"error" => "Tenant not found"}
  end

  test "DELETE /api/tenants/:id", %{conn: conn} do
    conn = insert_tenant(conn)
    id = json_response(conn, 201)["id"]

    conn = delete(conn, "/api/tenants/#{id}")
    failure_conn = delete(conn, "/api/tenants/#{id}")
    failure_find_conn = get(conn, "/api/tenants/#{id}")

    assert json_response(conn, 204) == %{"message" => "Tenant deleted"}
    assert json_response(failure_conn, 404) == %{"error" => "Tenant not found"}
    assert json_response(failure_find_conn, 404) == %{"error" => "Tenant not found"}
  end

  test "GET /api/tenants/:id/rents", %{conn: conn} do
    property_conn = insert_property(conn)
    id = json_response(property_conn, 201)["id"]

    tenant_conn = insert_tenant(conn)
    tenant_id = json_response(tenant_conn, 201)["id"]

    put(conn, "/api/properties/#{id}/tenants/#{tenant_id}")
    insert_rent(id, tenant_id)

    failure_conn = get(conn, "/api/tenants/#{tenant_id + 1}/rents")
    conn = get(conn, "/api/tenants/#{tenant_id}/rents")
    [rent] = json_response(conn, 200)["rents"]

    assert rent["property"]["id"] == id
    assert json_response(failure_conn, 404) == %{"error" => "Tenant not found"}
  end

  test "GET /api/tenants/:id/rents/unpaid", %{conn: conn} do
    property_conn = insert_property(conn)
    id = json_response(property_conn, 201)["id"]

    tenant_conn = insert_tenant(conn)
    tenant_id = json_response(tenant_conn, 201)["id"]

    put(conn, "/api/properties/#{id}/tenants/#{tenant_id}")
    insert_rent(id, tenant_id)

    failure_conn = get(conn, "/api/tenants/#{tenant_id + 1}/rents/unpaid")

    conn = get(conn, "/api/tenants/#{tenant_id}/rents/unpaid")
    [rent] = json_response(conn, 200)["rents"]

    assert rent["property"]["id"] == id
    assert json_response(failure_conn, 404) == %{"error" => "Tenant not found"}
  end
end
