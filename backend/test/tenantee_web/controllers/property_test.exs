defmodule TenanteeWeb.PropertyControllerTest do
  use TenanteeWeb.ConnCase
  use TenanteeWeb.PropertyCase
  use TenanteeWeb.TenantCase
  use TenanteeWeb.RentCase

  test "POST /api/properties", %{conn: conn} do
    conn = insert_property(conn)
    failure_conn = post conn, "/api/properties", property: %{name: "Test Property 2"}

    assert json_response(conn, 201)["name"] == "Test Property"
    assert json_response(failure_conn, 400) == %{"error" => "Invalid params"}
  end

  test "GET /api/properties/:id", %{conn: conn} do
    conn = insert_property(conn)
    id = json_response(conn, 201)["id"]

    conn = get(conn, "/api/properties/#{id}")

    assert json_response(conn, 200)["name"] == "Test Property"
  end

  test "GET /api/properties", %{conn: conn} do
    insert_property(conn)
    conn = get(conn, "/api/properties")

    assert json_response(conn, 200)["properties"] != []
  end

  test "PATCH /api/properties/:id", %{conn: conn} do
    conn = insert_property(conn)
    id = json_response(conn, 201)["id"]

    conn =
      patch conn, "/api/properties/#{id}", %{
        property: %{
          name: "Test Property 2",
          price: 1000,
          currency: "PHP"
        }
      }

    failure_conn = patch(conn, "/api/properties/#{id}")

    assert json_response(conn, 200)["name"] == "Test Property 2"

    assert json_response(conn, 200)["price"] == %{
             "amount" => 1000,
             "currency" => "PHP"
           }

    assert json_response(failure_conn, 400) == %{"error" => "Invalid params"}
  end

  test "DELETE /api/properties/:id", %{conn: conn} do
    conn = insert_property(conn)
    id = json_response(conn, 201)["id"]

    conn = delete(conn, "/api/properties/#{id}")
    failure_conn = delete(conn, "/api/properties/#{id}")
    failure_find_conn = get(conn, "/api/properties/#{id}")

    assert json_response(conn, 200) == %{"message" => "Property deleted"}
    assert json_response(failure_conn, 404) == %{"error" => "Property not found"}
    assert json_response(failure_find_conn, 404) == %{"error" => "Property not found"}
  end

  test "POST /api/properties/:id/tenants/:tenant", %{conn: conn} do
    property_conn = insert_property(conn)
    id = json_response(property_conn, 201)["id"]

    tenant_conn = insert_tenant(conn)
    tenant_id = json_response(tenant_conn, 201)["id"]

    conn = put(conn, "/api/properties/#{id}/tenants/#{tenant_id}")
    tenants = json_response(conn, 200)["tenants"]

    assert List.first(tenants)["id"] == tenant_id
  end

  test "DELETE /api/properties/:id/tenants/:tenant", %{conn: conn} do
    property_conn = insert_property(conn)
    id = json_response(property_conn, 201)["id"]

    tenant_conn = insert_tenant(conn)
    tenant_id = json_response(tenant_conn, 201)["id"]

    put(conn, "/api/properties/#{id}/tenants/#{tenant_id}")
    conn = delete(conn, "/api/properties/#{id}/tenants/#{tenant_id}")

    tenants = json_response(conn, 200)["tenants"]

    assert tenants == []
  end

  test "GET /api/properties/:id/rents/unpaid", %{conn: conn} do
    property_conn = insert_property(conn)
    id = json_response(property_conn, 201)["id"]

    tenant_conn = insert_tenant(conn)
    tenant_id = json_response(tenant_conn, 201)["id"]

    put(conn, "/api/properties/#{id}/tenants/#{tenant_id}")
    insert_rent(id, tenant_id)

    conn = get(conn, "/api/properties/#{id}/rents/unpaid")
    [rent] = json_response(conn, 200)["rents"]

    assert rent["tenant"]["id"] == tenant_id
  end
end
