defmodule TenanteeWeb.PropertyControllerTest do
  use TenanteeWeb.ConnCase
  use TenanteeWeb.PropertyCase
  use TenanteeWeb.TenantCase

  test "POST /api/properties", %{conn: conn} do
    conn = insert_property(conn)
    failure_conn = post conn, "/api/properties", property: %{name: "Test Property 2"}

    assert json_response(conn, 201)["property"]["name"] == "Test Property"
    assert json_response(failure_conn, 400) == %{"error" => "Invalid params"}
  end

  test "GET /api/properties/:id", %{conn: conn} do
    conn = insert_property(conn)
    id = json_response(conn, 201)["property"]["id"]

    conn = get(conn, "/api/properties/#{id}")

    assert json_response(conn, 200)["property"]["name"] == "Test Property"
  end

  test "GET /api/properties", %{conn: conn} do
    insert_property(conn)
    conn = get(conn, "/api/properties")

    assert json_response(conn, 200)["properties"] != []
  end

  test "PATCH /api/properties/:id", %{conn: conn} do
    conn = insert_property(conn)
    id = json_response(conn, 201)["property"]["id"]

    conn =
      patch conn, "/api/properties/#{id}", %{
        property: %{
          name: "Test Property 2",
          price: 1000
        }
      }

    failure_conn = patch(conn, "/api/properties/#{id}")

    assert json_response(conn, 200)["property"]["name"] == "Test Property 2"
    assert json_response(conn, 200)["property"]["price"]["amount"] == 1000
    assert json_response(failure_conn, 400) == %{"error" => "Invalid params"}
  end

  test "DELETE /api/properties/:id", %{conn: conn} do
    conn = insert_property(conn)
    id = json_response(conn, 201)["property"]["id"]

    conn = delete(conn, "/api/properties/#{id}")

    assert json_response(conn, 200) == %{"message" => "Property deleted"}

    conn = get(conn, "/api/properties/#{id}")

    assert json_response(conn, 404) == %{"error" => "Property not found"}
  end

  test "POST /api/properties/:id/tenants/:tenant", %{conn: conn} do
    property_conn = insert_property(conn)
    id = json_response(property_conn, 201)["property"]["id"]

    tenant_conn = insert_tenant(conn)
    tenant_id = json_response(tenant_conn, 201)["tenant"]["id"]

    conn = put(conn, "/api/properties/#{id}/tenants/#{tenant_id}")
    tenants = json_response(conn, 200)["property"]["tenants"]

    assert List.first(tenants)["id"] == tenant_id
  end

  test "DELETE /api/properties/:id/tenants/:tenant", %{conn: conn} do
    property_conn = insert_property(conn)
    id = json_response(property_conn, 201)["property"]["id"]

    tenant_conn = insert_tenant(conn)
    tenant_id = json_response(tenant_conn, 201)["tenant"]["id"]

    put(conn, "/api/properties/#{id}/tenants/#{tenant_id}")
    conn = delete(conn, "/api/properties/#{id}/tenants/#{tenant_id}")

    tenants = json_response(conn, 200)["property"]["tenants"]

    assert tenants == []
  end
end
