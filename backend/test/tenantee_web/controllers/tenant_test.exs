defmodule TenanteeWeb.TenantControllerTest do
  use TenanteeWeb.ConnCase
  use TenanteeWeb.TenantCase

  test "POST /api/tenants", %{conn: conn} do
    conn = insert_tenant(conn)
    failure_conn = post(conn, "/api/tenants")

    assert json_response(conn, 201)["tenant"]["id"] != nil
    assert json_response(failure_conn, 400) == %{"error" => "Invalid params"}
  end

  test "GET /api/tenants/:id", %{conn: conn} do
    conn = insert_tenant(conn)
    id = json_response(conn, 201)["tenant"]["id"]

    conn = get(conn, "/api/tenants/#{id}")

    assert json_response(conn, 200)["tenant"]["id"] == id
  end

  test "GET /api/tenants", %{conn: conn} do
    insert_tenant(conn)

    conn = get(conn, "/api/tenants")

    assert json_response(conn, 200)["tenants"] != []
  end

  test "PATCH /api/tenants/:id", %{conn: conn} do
    conn = insert_tenant(conn)
    id = json_response(conn, 201)["tenant"]["id"]

    conn =
      patch(conn, "/api/tenants/#{id}", %{
        tenant: %{
          first_name: "Updated"
        }
      })

    failure_conn = patch(conn, "/api/tenants/#{id}", %{})

    assert json_response(conn, 200)["tenant"]["name"] == "Updated Tenant"
    assert json_response(failure_conn, 400) == %{"error" => "Invalid params"}
  end

  test "DELETE /api/tenants/:id", %{conn: conn} do
    conn = insert_tenant(conn)
    id = json_response(conn, 201)["tenant"]["id"]

    conn = delete(conn, "/api/tenants/#{id}")
    failure_conn = delete(conn, "/api/tenants/#{id}")
    failure_find_conn = get(conn, "/api/tenants/#{id}")

    assert json_response(conn, 200) == %{"message" => "Tenant deleted"}
    assert json_response(failure_conn, 404) == %{"error" => "Tenant not found"}
    assert json_response(failure_find_conn, 404) == %{"error" => "Tenant not found"}
  end
end
