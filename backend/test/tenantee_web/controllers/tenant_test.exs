defmodule TenanteeWeb.TenantControllerTest do
  use TenanteeWeb.ConnCase
  use TenanteeWeb.PropertyCase
  use TenanteeWeb.TenantCase
  use TenanteeWeb.RentCase

  describe "POST /api/tenants" do
    test "happy path", %{conn: conn} do
      tenant = insert_tenant(conn)

      assert json_response(tenant, 201)["id"] != nil
    end

    test "invalid parameters", %{conn: conn} do
      tenant = post(conn, "/api/tenants", %{})

      assert json_response(tenant, 422)["message"] == "Invalid tenant"
    end
  end

  describe "GET /api/tenants/:id" do
    test "happy path", %{conn: conn} do
      tenant = insert_tenant(conn)
      id = json_response(tenant, 201)["id"]

      conn = get(conn, "/api/tenants/#{id}")

      assert json_response(conn, 200)["id"] == id
    end

    test "not found", %{conn: conn} do
      conn = get(conn, "/api/tenants/0")

      assert json_response(conn, 404)["message"] == "Tenant not found"
    end
  end

  test "GET /api/tenants", %{conn: conn} do
    insert_tenant(conn)

    conn = get(conn, "/api/tenants")

    assert json_response(conn, 200)["tenants"] != []
  end

  describe "PATCH /api/tenants/:id" do
    test "happy path", %{conn: conn} do
      tenant = insert_tenant(conn)
      id = json_response(tenant, 201)["id"]

      conn = patch(conn, "/api/tenants/#{id}", %{first_name: "New", last_name: "name"})

      assert json_response(conn, 200)["name"] == "New name"
    end

    test "not found", %{conn: conn} do
      conn = patch(conn, "/api/tenants/0", %{first_name: "New", last_name: "name"})

      assert json_response(conn, 404)["message"] == "Tenant not found"
    end
  end

  describe "DELETE /api/tenants/:id" do
    test "happy path", %{conn: conn} do
      tenant = insert_tenant(conn)
      id = json_response(tenant, 201)["id"]

      conn = delete(conn, "/api/tenants/#{id}")

      assert json_response(conn, 204)["message"] == "Tenant deleted"
    end

    test "not found", %{conn: conn} do
      conn = delete(conn, "/api/tenants/0")

      assert json_response(conn, 404)["message"] == "Tenant not found"
    end
  end

  describe "GET /api/tenants/:id/rents" do
    test "happy path", %{conn: conn} do
      property = insert_property(conn)
      property_id = json_response(property, 201)["id"]
      tenant = insert_tenant(conn)
      tenant_id = json_response(tenant, 201)["id"]
      insert_rent(property_id, tenant_id)

      conn = get(conn, "/api/tenants/#{tenant_id}/rents")

      assert json_response(conn, 200)["rents"] != []
    end

    test "not found", %{conn: conn} do
      conn = get(conn, "/api/tenants/0/rents")

      assert json_response(conn, 404)["message"] == "Tenant not found"
    end
  end

  describe "GET /api/tenants/:id/rents/unpaid" do
    test "happy path", %{conn: conn} do
      property = insert_property(conn)
      property_id = json_response(property, 201)["id"]
      tenant = insert_tenant(conn)
      tenant_id = json_response(tenant, 201)["id"]
      insert_rent(property_id, tenant_id)

      conn = get(conn, "/api/tenants/#{tenant_id}/rents/unpaid")

      assert json_response(conn, 200)["rents"] != []
    end

    test "not found", %{conn: conn} do
      conn = get(conn, "/api/tenants/0/rents/unpaid")

      assert json_response(conn, 404)["message"] == "Tenant not found"
    end
  end
end
