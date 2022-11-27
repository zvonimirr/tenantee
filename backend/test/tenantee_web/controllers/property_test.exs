defmodule TenanteeWeb.PropertyControllerTest do
  use TenanteeWeb.ConnCase
  use TenanteeWeb.PropertyCase
  use TenanteeWeb.TenantCase
  use TenanteeWeb.RentCase

  describe "POST /api/properties" do
    test "happy path", %{conn: conn} do
      conn = insert_property(conn)

      assert json_response(conn, 201)["name"] == "Test Property"
    end

    test "invalid currency", %{conn: conn} do
      conn =
        post(conn, "/api/properties", %{
          "property" => %{
            "name" => "Test Property",
            "location" => "Test Location",
            "currency" => "invalid",
            "price" => 1000
          }
        })

      assert json_response(conn, 422)["error"] == "Invalid currency"
    end

    test "invalid params", %{conn: conn} do
      conn = post(conn, "/api/properties", %{})

      assert json_response(conn, 422)["error"] == "Invalid property"
    end
  end

  describe "GET /api/properties/:id" do
    test "happy path", %{conn: conn} do
      conn = insert_property(conn)
      id = json_response(conn, 201)["id"]

      conn = get(conn, "/api/properties/#{id}")

      assert json_response(conn, 200)["name"] == "Test Property"
    end

    test "not found", %{conn: conn} do
      conn = get(conn, "/api/properties/0")

      assert json_response(conn, 404)["error"] == "Property not found"
    end
  end

  test "GET /api/properties", %{conn: conn} do
    insert_property(conn)
    conn = get(conn, "/api/properties")

    assert json_response(conn, 200)["properties"] != []
  end

  describe "PATCH /api/properties/:id" do
    test "happy path", %{conn: conn} do
      conn = insert_property(conn)
      id = json_response(conn, 201)["id"]

      conn =
        patch(conn, "/api/properties/#{id}", %{
          "property" => %{
            "name" => "Updated Property",
            "location" => "Updated Location",
            "currency" => "USD",
            "price" => 1000
          }
        })

      assert json_response(conn, 200)["name"] == "Updated Property"
    end

    test "invalid currency", %{conn: conn} do
      conn = insert_property(conn)
      id = json_response(conn, 201)["id"]

      conn =
        patch(conn, "/api/properties/#{id}", %{
          "property" => %{
            "name" => "Updated Property",
            "location" => "Updated Location",
            "currency" => "invalid",
            "price" => 1000
          }
        })

      assert json_response(conn, 422)["error"] == "Invalid currency"
    end

    test "invalid params", %{conn: conn} do
      conn = insert_property(conn)
      id = json_response(conn, 201)["id"]

      conn = patch(conn, "/api/properties/#{id}", %{})

      assert json_response(conn, 422)["error"] == "Invalid property"
    end

    test "not found", %{conn: conn} do
      conn =
        patch(conn, "/api/properties/0", %{
          "property" => %{
            "name" => "Updated Property",
            "location" => "Updated Location",
            "currency" => "USD",
            "price" => 1000
          }
        })

      assert json_response(conn, 404)["error"] == "Property not found"
    end
  end

  describe "DELETE /api/properties/:id" do
    test "happy path", %{conn: conn} do
      conn = insert_property(conn)
      id = json_response(conn, 201)["id"]

      conn = delete(conn, "/api/properties/#{id}")

      assert json_response(conn, 204)["message"] == "Property deleted"
    end

    test "not found", %{conn: conn} do
      conn = delete(conn, "/api/properties/0")

      assert json_response(conn, 404)["error"] == "Property not found"
    end
  end

  describe "PUT /api/properties/:id/tenants/:tenant" do
    test "happy path", %{conn: conn} do
      conn = insert_property(conn)
      id = json_response(conn, 201)["id"]
      conn = insert_tenant(conn)
      tenant = json_response(conn, 201)["id"]

      conn = put(conn, "/api/properties/#{id}/tenants/#{tenant}")

      tenants = json_response(conn, 201)["tenants"]
      assert List.first(tenants)["id"] == tenant
    end

    test "not found", %{conn: conn} do
      conn = put(conn, "/api/properties/0/tenants/0")

      assert json_response(conn, 404)["error"] == "Property or tenant not found"
    end
  end

  describe "DELETE /api/properties/:id/tenants/:tenant" do
    test "happy path", %{conn: conn} do
      conn = insert_property(conn)
      id = json_response(conn, 201)["id"]
      conn = insert_tenant(conn)
      tenant = json_response(conn, 201)["id"]
      conn = put(conn, "/api/properties/#{id}/tenants/#{tenant}")

      conn = delete(conn, "/api/properties/#{id}/tenants/#{tenant}")

      assert json_response(conn, 204)["tenants"] == []
    end

    test "not found", %{conn: conn} do
      conn = delete(conn, "/api/properties/0/tenants/0")

      assert json_response(conn, 404)["error"] == "Property or tenant not found"
    end
  end

  describe "GET /api/properties/:id/rents/unpaid" do
    test "happy path", %{conn: conn} do
      conn = insert_property(conn)
      id = json_response(conn, 201)["id"]
      conn = insert_tenant(conn)
      tenant = json_response(conn, 201)["id"]
      conn = put(conn, "/api/properties/#{id}/tenants/#{tenant}")
      insert_rent(id, tenant)

      conn = get(conn, "/api/properties/#{id}/rents/unpaid")

      assert List.first(json_response(conn, 200)["rents"])["tenant"]["id"] == tenant
    end

    test "not found", %{conn: conn} do
      conn = get(conn, "/api/properties/0/rents/unpaid")

      assert json_response(conn, 404)["error"] == "Property not found"
    end
  end
end
