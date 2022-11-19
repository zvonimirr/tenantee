defmodule TenanteeWeb.PropertyControllerTest do
  use TenanteeWeb.ConnCase

  defp insert(conn) do
    post conn, "/api/properties", %{
      property: %{
        name: "Test Property",
        location: "Test Location",
        description: "Test Description",
        price: 100
      }
    }
  end

  test "POST /api/properties", %{conn: conn} do
    conn = insert(conn)

    assert json_response(conn, 201)["property"]["name"] == "Test Property"
  end

  test "GET /api/properties/:id", %{conn: conn} do
    conn = insert(conn)
    id = json_response(conn, 201)["property"]["id"]

    conn = get(conn, "/api/properties/#{id}")
    assert json_response(conn, 200)["property"]["name"] == "Test Property"
  end

  test "GET /api/properties", %{conn: conn} do
    insert(conn)
    conn = get(conn, "/api/properties")

    assert json_response(conn, 200)["properties"] != []
  end

  test "PATCH /api/properties/:id", %{conn: conn} do
    conn = insert(conn)
    id = json_response(conn, 201)["property"]["id"]

    conn =
      patch conn, "/api/properties/#{id}", %{
        property: %{
          name: "Test Property 2"
        }
      }

    assert json_response(conn, 200)["property"]["name"] == "Test Property 2"
  end

  test "DELETE /api/properties/:id", %{conn: conn} do
    conn = insert(conn)
    id = json_response(conn, 201)["property"]["id"]

    conn = delete(conn, "/api/properties/#{id}")

    assert json_response(conn, 200) == %{"message" => "Property deleted"}

    conn = get(conn, "/api/properties/#{id}")

    assert json_response(conn, 404) == %{"error" => "Property not found"}
  end
end
