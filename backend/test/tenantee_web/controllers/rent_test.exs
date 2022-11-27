defmodule TenanteeWeb.RentControllerTest do
  use TenanteeWeb.ConnCase
  use TenanteeWeb.PropertyCase
  use TenanteeWeb.TenantCase
  use TenanteeWeb.RentCase

  setup %{conn: conn} do
    property_conn = insert_property(conn)
    property_id = json_response(property_conn, 201)["id"]

    tenant_conn = insert_tenant(conn)
    tenant_id = json_response(tenant_conn, 201)["id"]

    rent = insert_rent(property_id, tenant_id)

    {:ok, %{rent_id: Map.get(rent, :id), property_id: property_id, tenant_id: tenant_id}}
  end

  test "GET /api/rent", %{
    conn: conn,
    rent_id: rent_id,
    property_id: property_id,
    tenant_id: tenant_id
  } do
    conn = get(conn, "/api/rent")

    assert json_response(conn, 200)["rents"] == [
             %{
               "due_date" => "2022-11-23",
               "id" => rent_id,
               "paid" => false,
               "property" => %{"id" => property_id, "name" => "Test Property"},
               "tenant" => %{"id" => tenant_id, "name" => "Test Tenant"}
             }
           ]
  end

  test "GET /api/rent/paid", %{
    conn: conn
  } do
    conn = get(conn, "/api/rent/paid")

    assert json_response(conn, 200)["rents"] == []
  end

  test "GET /api/rent/unpaid", %{
    conn: conn,
    rent_id: rent_id,
    property_id: property_id,
    tenant_id: tenant_id
  } do
    conn = get(conn, "/api/rent/unpaid")

    assert json_response(conn, 200)["rents"] == [
             %{
               "due_date" => "2022-11-23",
               "id" => rent_id,
               "paid" => false,
               "property" => %{"id" => property_id, "name" => "Test Property"},
               "tenant" => %{"id" => tenant_id, "name" => "Test Tenant"}
             }
           ]
  end

  describe "POST /api/rent/:id/mark-as-paid" do
    test "happy path", %{
      conn: conn,
      rent_id: rent_id
    } do
      conn = post(conn, "/api/rent/#{rent_id}/mark-as-paid")

      assert json_response(conn, 200) == %{
               "due_date" => "2022-11-23",
               "id" => rent_id,
               "paid" => true
             }
    end

    test "not found", %{
      conn: conn
    } do
      conn = post(conn, "/api/rent/0/mark-as-paid")

      assert json_response(conn, 404)["message"] == "Rent not found"
    end
  end

  describe "POST /api/rent/:id/mark-as-unpaid" do
    test "happy path", %{
      conn: conn,
      rent_id: rent_id
    } do
      conn = post(conn, "/api/rent/#{rent_id}/mark-as-unpaid")

      assert json_response(conn, 200) == %{
               "due_date" => "2022-11-23",
               "id" => rent_id,
               "paid" => false
             }
    end

    test "not found", %{
      conn: conn
    } do
      conn = post(conn, "/api/rent/0/mark-as-unpaid")

      assert json_response(conn, 404)["message"] == "Rent not found"
    end
  end
end
