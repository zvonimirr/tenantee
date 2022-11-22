defmodule TenanteeWeb.Router do
  use TenanteeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/swagger" do
    # coveralls-ignore-start
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :tenantee,
      swagger_file: "swagger.json"

    # coveralls-ignore-stop
  end

  scope "/api", TenanteeWeb do
    pipe_through :api

    get "/health-check", HealthCheckController, :index

    scope "/properties" do
      post "/", PropertyController, :add
      get "/", PropertyController, :list
      get "/:id", PropertyController, :find
      patch "/:id", PropertyController, :update
      delete "/:id", PropertyController, :delete_by_id
      put "/:id/tenants/:tenant", PropertyController, :add_tenant
      delete "/:id/tenants/:tenant", PropertyController, :remove_tenant
    end

    scope "/tenants" do
      post "/", TenantController, :add
      get "/", TenantController, :list
      get "/:id", TenantController, :find
      patch "/:id", TenantController, :update
      delete "/:id", TenantController, :delete_by_id
    end
  end

  # coveralls-ignore-start
  def swagger_info do
    %{
      schemes: ["http", "https"],
      info: %{
        title: "Tenantee API",
        version: Keyword.get(Tenantee.MixProject.project(), :version),
        description: "API for the Tenantee platform"
      },
      consumes: ["application/json"],
      produces: ["application/json"],
      tags: [
        %{
          name: "General",
          description: "General API information"
        },
        %{
          name: "Property",
          description: "Property management"
        },
        %{
          name: "Tenant",
          description: "Tenant management"
        }
      ]
    }
  end

  # coveralls-ignore-stop
end
