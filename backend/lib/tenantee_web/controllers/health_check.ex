defmodule TenanteeWeb.HealthCheckController do
  use TenanteeWeb, :controller
  use PhoenixSwagger

  swagger_path :index do
    get("/api/health-check")
    tag("General")
    summary("Health check")
    description("Returns a 200 OK if the service is up and running")
    produces("application/json")
    response(200, "OK", Schema.ref(:HealthCheck))
  end

  def index(conn, _params) do
    render(conn, "index.json", %{message: "Tenantee is up and running!"})
  end

  def swagger_definitions do
    %{
      HealthCheck:
        swagger_schema do
          title("Health Check")
          description("Health check response")

          properties do
            message(:string, "Should be 'Tenantee is up and running!'", required: true)
          end

          example(%{
            message: "Tenantee is up and running!"
          })
        end
    }
  end
end
