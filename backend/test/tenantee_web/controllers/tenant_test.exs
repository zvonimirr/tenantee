defmodule TenanteeWeb.TenantControllerTest do
  use TenanteeWeb.ConnCase

  defp insert(conn) do
    post conn, "/api/tenants", %{
      tenant: %{
        first_name: "Test",
        last_name: "Tenant"
      }
    }
  end

  test "POST /api/tenants", %{conn: conn} do
    conn = insert(conn)

    assert json_response(conn, 201)["tenant"]["id"] != nil
  end

  test "GET /api/tenants/:id", %{conn: conn} do
    conn = insert(conn)
    id = json_response(conn, 201)["tenant"]["id"]

    conn = get(conn, "/api/tenants/#{id}")

    assert json_response(conn, 200)["tenant"]["id"] == id
  end

  test "GET /api/tenants", %{conn: conn} do
    insert(conn)

    conn = get(conn, "/api/tenants")

    assert json_response(conn, 200)["tenants"] != []
  end

  test "PATCH /api/tenants/:id", %{conn: conn} do
    conn = insert(conn)
    id = json_response(conn, 201)["tenant"]["id"]

    conn =
      patch(conn, "/api/tenants/#{id}", %{
        tenant: %{
          first_name: "Updated"
        }
      })

    assert json_response(conn, 200)["tenant"]["name"] == "Updated Tenant"
  end

  test "DELETE /api/tenants/:id", %{conn: conn} do
    conn = insert(conn)
    id = json_response(conn, 201)["tenant"]["id"]

    conn = delete(conn, "/api/tenants/#{id}")

    assert json_response(conn, 200) == %{"message" => "Tenant deleted"}

    conn = get(conn, "/api/tenants/#{id}")

    assert json_response(conn, 404) == %{"error" => "Tenant not found"}
  end
end
