defmodule TenanteeWeb.RentControllerTest do
  use TenanteeWeb.ConnCase

  setup %{conn: _conn} do
    %{id: property_id} = Tenantee.Factory.Property.insert(name: "Test Property")

    %{id: tenant_id} = Tenantee.Factory.Tenant.insert(first_name: "Test", last_name: "Tenant")

    %{id: rent_id} =
      Tenantee.Factory.Rent.insert(property_id, tenant_id, due_date: ~D[2022-11-23])

    {:ok, %{rent_id: rent_id, property_id: property_id, tenant_id: tenant_id}}
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
