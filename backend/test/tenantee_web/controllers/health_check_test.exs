defmodule TenanteeWeb.HealthCheckControllerTest do
  use TenanteeWeb.ConnCase, async: true

  test "GET /api/health-check", %{conn: conn} do
    conn = get(conn, "/api/health-check")
    assert json_response(conn, 200) == %{"message" => "Tenantee is up and running!"}
  end
end
