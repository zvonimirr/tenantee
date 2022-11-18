defmodule TenanteeWeb.HealthCheckController do
  use TenanteeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.json", %{message: "Tenantee is up and running!"})
  end
end
